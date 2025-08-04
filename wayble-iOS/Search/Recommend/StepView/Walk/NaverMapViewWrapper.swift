//
//  NaverMapViewWrapper.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/29/25.
//

import SwiftUI
import NMapsMap

struct NaverMapViewWrapper: UIViewRepresentable {
    var route: RouteData
    func makeUIView(context: Context) -> NMFMapView {
        let mapView = NMFMapView()
        

        let start = route.path.first!
        let end = route.path.last!
        let center = NMGLatLng(lat: (start.lat + end.lat) / 2, lng: (start.lng + end.lng) / 2)
        let zoom = calculateZoomLevel(start: start, end: end)
        let cameraPosition = NMFCameraPosition(center, zoom: zoom, tilt: 0, heading: 0)
        let cameraUpdate = NMFCameraUpdate(position: cameraPosition)
        mapView.moveCamera(cameraUpdate)

        // 출발/도착 마커
        addMarker(imageName: "start2", position: route.path.first!, mapView: mapView)
        addMarker(imageName: "fin2", position: route.path.last!, mapView: mapView)

        // 휠체어 마커
        for point in route.wheelchairPoints ?? [] {
            addMarker(imageName: "icon1", position: point, mapView: mapView)
        }

        // 엘리베이터 마커
        for point in route.elevatorPoints ?? [] {
            addMarker(imageName: "icon2", position: point, mapView: mapView)
        }

        // 경로 그리기
        let pathOverlay = NMFPath()
        pathOverlay.path = NMGLineString(points: route.path)
        pathOverlay.width = 12
        pathOverlay.color = route.lineColor
        pathOverlay.patternIcon = NMFOverlayImage(name: "dot")
        pathOverlay.patternInterval = 4
        pathOverlay.outlineColor = .white
        pathOverlay.outlineWidth = 2
        pathOverlay.mapView = mapView

        return mapView
    }

    func updateUIView(_ uiView: NMFMapView, context: Context) {}

    private func addMarker(imageName: String, position: NMGLatLng, mapView: NMFMapView) {
        let marker = NMFMarker(position: position)
        marker.iconImage = NMFOverlayImage(name: imageName)
        marker.mapView = mapView
    }
    
    private func calculateZoomLevel(start: NMGLatLng, end: NMGLatLng) -> Double {
        let distance = start.distance(to: end) // 단위: 미터

        switch distance {
        case 0..<500: return 17.5 // 가까우면 더 확대
        case 500..<1000: return 16
        case 1000..<3000: return 15
        case 3000..<5000: return 14
        case 5000..<10000: return 13.5
        case 10000..<15000: return 13
        case 15000..<30000: return 12
        default: return 11.5 // 30km 이하 마지막 대응
        }
    }
}
#Preview {
    NaverMapViewWrapper(
        route: SampleRoutes.wayble
    )
}
