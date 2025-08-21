//
//  NaverMapViewWrapper.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/29/25.
//

import SwiftUI
import NMapsMap

struct NaverMapViewWrapper: UIViewRepresentable {
    final class Coordinator: NSObject, NMFMapViewCameraDelegate {
        var path: NMFPath?
        var markers: [NMFMarker] = []
        // 최근 카메라 fit에 사용한 경로 시그니처 (변경 감지용)
        var lastFitSignature: String?
        
        // 항상 dot 패턴, dot 간격을 화면 픽셀 기준으로 고정, 항상 표시
        func updateStyle(for mapView: NMFMapView) {
            guard let path = path else { return }
            
            // 항상 dot 패턴 사용
            path.patternIcon = NMFOverlayImage(name: "dot")
            
            // 화면 픽셀 기준으로 간격 고정 (줌 인/아웃해도 시각적 간격 동일)
            let fixedPixelInterval: Double = 7  //여기를 조정
            path.patternInterval = UInt(fixedPixelInterval)
            
            // 선 굵기도 픽셀 기준으로 고정
            path.width = CGFloat(10)
            
            // 다른 오버레이에 가려지지 않도록
            path.zIndex = 1000
        }
        
        func signature(for points: [NMGLatLng]) -> String {
            guard let first = points.first else { return "empty" }
            var minLat = first.lat, maxLat = first.lat
            var minLng = first.lng, maxLng = first.lng
            for p in points.dropFirst() {
                minLat = min(minLat, p.lat); maxLat = max(maxLat, p.lat)
                minLng = min(minLng, p.lng); maxLng = max(maxLng, p.lng)
            }
            return "\(points.count)-\(minLat)-\(minLng)-\(maxLat)-\(maxLng)"
        }
        
        // 카메라 변경 시 실시간 반영
        func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
            updateStyle(for: mapView)
        }
    }
    
    func makeCoordinator() -> Coordinator { Coordinator() }
    
    // 전체 경로를 감싸는 bounds 계산
    private func bounds(for points: [NMGLatLng]) -> NMGLatLngBounds? {
        guard let first = points.first else { return nil }
        var minLat = first.lat, maxLat = first.lat
        var minLng = first.lng, maxLng = first.lng
        for p in points.dropFirst() {
            minLat = min(minLat, p.lat); maxLat = max(maxLat, p.lat)
            minLng = min(minLng, p.lng); maxLng = max(maxLng, p.lng)
        }
        return NMGLatLngBounds(
            southWest: NMGLatLng(lat: minLat, lng: minLng),
            northEast: NMGLatLng(lat: maxLat, lng: maxLng)
        )
    }
    
    // bounds + 패딩으로 항상 한 화면에 경로가 보이도록 카메라 맞춤
    private func moveCameraToFit(points: [NMGLatLng], on mapView: NMFMapView) {
        guard let b = bounds(for: points) else { return }
        // 상/좌/하/우 패딩 (상단 검색창, 하단 바텀 박스 고려)
        let insets = UIEdgeInsets(top: 80, left: 24, bottom: 200, right: 24)
        let update = NMFCameraUpdate(fit: b, paddingInsets: insets)
        mapView.moveCamera(update)
    }
    
    // 뷰 사이즈가 0일 때 fitBounds가 실패할 수 있어서 짧게 재시도하며 맞춤
    private func waitAndFit(points: [NMGLatLng], on mapView: NMFMapView, retry: Int = 6) {
        guard retry > 0 else { return }
        if mapView.bounds.size.width > 0, mapView.bounds.size.height > 0 {
            moveCameraToFit(points: points, on: mapView)
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                waitAndFit(points: points, on: mapView, retry: retry - 1)
            }
        }
    }
    
    var route: RouteData
    func makeUIView(context: Context) -> NMFMapView {
        let mapView = NMFMapView()
        mapView.addCameraDelegate(delegate: context.coordinator)

        //  경로가 비어있을 때 크래시 방지: 기본 카메라만 세팅하고 반환
        guard let start = route.path.first, let end = route.path.last else {
            let fallback = NMGLatLng(lat: 37.5665, lng: 126.9780) // 기본 위치(서울 시청 등)
            let camera = NMFCameraPosition(fallback, zoom: 15)
            let cameraUpdate = NMFCameraUpdate(position: camera)
            mapView.moveCamera(cameraUpdate)
            return mapView
        }

        // 경로 전체가 항상 보이도록 자동 맞춤
        
        DispatchQueue.main.async {
            waitAndFit(points: route.path, on: mapView)
            context.coordinator.lastFitSignature = context.coordinator.signature(for: route.path)
        }

        // 출발/도착 마커
        let startMarker = NMFMarker(position: start)
        startMarker.iconImage = NMFOverlayImage(name: "start2")
        startMarker.mapView = mapView
        
        let endMarker = NMFMarker(position: end)
        endMarker.iconImage = NMFOverlayImage(name: "fin2")
        endMarker.mapView = mapView
        
        context.coordinator.markers = [startMarker, endMarker]

        // 휠체어 마커
        for point in route.wheelchairPoints ?? [] {
            addMarker(imageName: "icon1", position: point, mapView: mapView)
        }

        // 엘리베이터 마커
        for point in route.elevatorPoints ?? [] {
            addMarker(imageName: "icon2", position: point, mapView: mapView)
        }

        // 경로 그리기
        let path = NMFPath()
        path.path = NMGLineString(points: route.path)
        path.color = route.lineColor
        path.outlineColor = .white
        path.outlineWidth = 2
        // 초기 스타일 1회 적용
        context.coordinator.path = path
        context.coordinator.updateStyle(for: mapView)
        path.mapView = mapView

        return mapView
    }

    func updateUIView(_ uiView: NMFMapView, context: Context) {
        // 1) 경로가 비었으면 오버레이 숨기고 종료
        guard let first = route.path.first, let last = route.path.last, !route.path.isEmpty else {
            context.coordinator.path?.mapView = nil
            return
        }
    
        // 2) 경로/마커 내용 업데이트 (강참조된 객체 재사용)
        if let path = context.coordinator.path {
            path.path = NMGLineString(points: route.path)
            // 스타일도 한 번 갱신
            context.coordinator.updateStyle(for: uiView)
            // 보장: 맵에 붙어있지 않다면 붙인다
            if path.mapView == nil { path.mapView = uiView }
        }
    
        if context.coordinator.markers.count >= 2 {
            context.coordinator.markers[0].position = first
            context.coordinator.markers[1].position = last
            // 보장: 맵에 붙어있지 않다면 붙인다
            if context.coordinator.markers[0].mapView == nil { context.coordinator.markers[0].mapView = uiView }
            if context.coordinator.markers[1].mapView == nil { context.coordinator.markers[1].mapView = uiView }
        }
    
        // 3) 경로가 바뀌면(길이/경계가 달라지면) 카메라를 다시 맞춘다 (레이아웃 안정화 후)
        let sig = context.coordinator.signature(for: route.path)
        if sig != context.coordinator.lastFitSignature {
            DispatchQueue.main.async {
                waitAndFit(points: route.path, on: uiView)
                context.coordinator.lastFitSignature = sig
            }
        }
    }

    private func addMarker(imageName: String, position: NMGLatLng, mapView: NMFMapView) {
        let marker = NMFMarker(position: position)
        marker.iconImage = NMFOverlayImage(name: imageName)
        marker.mapView = mapView
    }
    
 
}

