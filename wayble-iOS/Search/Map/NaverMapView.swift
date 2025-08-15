//
//  NaverMapView.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/25/25.
//

import SwiftUI
import NMapsMap
import NMapsGeometry



struct NaverMapView: UIViewRepresentable {
    let centerX: Double
    let centerY: Double
    var onLocationChanged: ((Double, Double) -> Void)? = nil
    let zoomLevel: Double
    var showMarker: Bool = true  // mapDetailView 에서만 보여주기
    var facilities: [HomeFacility] = [] ///MainMapView에서 사용 여러 마커를 받을 수 있게 파라미터 추가 0813
    
    
    func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

    
    func makeUIView(context: Context) -> NMFMapView {
        
        let mapView = NMFMapView()
        mapView.minZoomLevel = 5.0
        mapView.maxZoomLevel = 21.0
        mapView.isZoomGestureEnabled = true
        let cameraLat = centerY
        let cameraLng = centerX + 0.0029
        let cameraPosition = NMFCameraPosition(
            NMGLatLng(lat: cameraLat, lng: cameraLng),
            zoom: zoomLevel
        )
        mapView.moveCamera(NMFCameraUpdate(position: cameraPosition))
        mapView.addCameraDelegate(delegate: context.coordinator)
        
        ///makeUIView, updateUIView에서 호출해서 초기/변경 시마다 갱신
        context.coordinator.renderMarkers(on: mapView, facilities: facilities)
        
        if showMarker {
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: centerY, lng: centerX)
            marker.iconImage = NMFOverlayImage(name: "pin11")
            marker.width = 46
            marker.height = 58.78
            marker.mapView = mapView
            marker.anchor = CGPoint(x: 0.5, y: 1.0)
        }

        return mapView
    }
    
    
    func updateUIView(_ uiView: NMFMapView, context: Context) {
        // Skip work if there are no facilities to render (prevents noisy loops)
        guard !facilities.isEmpty else { return }
        //사용자 입장에서 마커가 가운데에 보이게 !!
        DispatchQueue.main.async {
            let cameraLat = centerY
            let cameraLng = centerX
            let target = NMGLatLng(lat: cameraLat, lng: cameraLng)
            let update = NMFCameraUpdate(scrollTo: target) // preserve current zoom level
            uiView.moveCamera(update)
            // Re-render markers when facilities are updated
            context.coordinator.renderMarkers(on: uiView, facilities: facilities)
        }
    }
    class Coordinator: NSObject, NMFMapViewCameraDelegate {
        var parent: NaverMapView
        private var markers: [NMFMarker] = []
        private var lastFacilitiesSignature: String?
        private var didFitForSignature: String?
        
        init(_ parent: NaverMapView) {
            self.parent = parent
        }
        
        func mapViewCameraIdle(_ mapView: NMFMapView) {
            let center = mapView.cameraPosition.target
            DispatchQueue.main.async {
                self.parent.onLocationChanged?(center.lat, center.lng)
            }
            // 추후 추가할 로직 예: viewModel.callReverseGeocodeAPI(lat: center.lat, lng: center.lng)
        }
        
        /// 시설 타입별 마커 스타일 매핑
        private func markerStyle(for facilityType: String) -> (iconName: String, width: CGFloat, height: CGFloat) {
            switch facilityType.uppercased() {
            case "ELEVATOR":
                return ("pin5", 46, 58.78)
            case "RAMP":
                return ("pin3", 46, 58.78)
            case "TOILET":
                return ("pin12", 46, 58.78)
            case "WHEELCHAIR_CHARGE":
                return ("pin1", 46, 58.78)
            default:
                return ("pin11", 46, 58.78)
            }
        }
        
        //MARK: - (마커 배열) 위치 목록(facilities)을 받아서 기존 마커를 지우고 새 마커로 갈아끼우는 역할
        
        ///mapView ; NMFMapView 인스턴스 (실제로 화면에 보이는 지도)
        ///marker ; NMFMarker 객체 (네이버 지도 SDK에서 마커를 나타내는 클래스)
        
        func renderMarkers(on mapView: NMFMapView, facilities: [HomeFacility]) {
            // Build a lightweight change signature to avoid re-rendering identical markers
            let signature: String = facilities.map { f in
                "\(String(format: "%.6f", f.latitude)),\(String(format: "%.6f", f.longitude)),\(f.facilityType.uppercased())"
            }.joined(separator: "|")

            if signature == lastFacilitiesSignature {
                // No change in facilities; skip heavy re-render to prevent infinite loops/log spam
                return
            }
            lastFacilitiesSignature = signature

            print("[Map] facilities.count = \(facilities.count)")
            /// 기존에 찍혀 있던 마커들을 지도에서 제거 - m.mapView = nil 하면 마커가 지도에서 사라짐)
            for marker in markers { marker.mapView = nil }
            markers.removeAll()

            /// facilities 배열 for문으로 돌면서  각 시설 좌표로 새 마커 생성
            for f in facilities {
                let marker = NMFMarker()
                marker.position = NMGLatLng(lat: f.latitude, lng: f.longitude) // 마커 좌표 지정
                // Prevent auto-hiding when symbols/captions collide
                marker.isHideCollidedSymbols = false
                marker.isHideCollidedCaptions = false
                print("[Map] marker lat=\(f.latitude), lng=\(f.longitude)")

                // 시설 타입별 아이콘/사이즈/캡션 적용
                let style = markerStyle(for: f.facilityType)
                if let uiImage = UIImage(named: style.iconName) {
                    marker.iconImage = NMFOverlayImage(image: uiImage)
                } else {
                    // Fallback: show default blue marker if asset missing / not in target
                    marker.iconImage = NMF_MARKER_IMAGE_BLUE
                }
                marker.width = style.width
                marker.height = style.height

                marker.anchor = CGPoint(x: 0.5, y: 1.0)
                ///핀 하단 중앙을 좌표에 맞춤
                ///marker.anchor ; 마커 이미지의 어느 지점을 지도 좌표와 맞출지를 결정 - 핀 모양 아이콘의 “뾰족한 끝”이 좌표를 가리키게 하려면 y: 1.0으로 설정
                ///마커의 앵커 포인트(0.5, 1.0이면 가로 중앙, 세로 하단이 좌표에 맞게 고정됨)
                
                
                //marker.zIndex = 1 // 기본 마커보다 위에 표시되도록 (필요시 조정) - 필요한가
                marker.zIndex = 1000
                marker.mapView = mapView /// 마커가 해당 지도에 등록돼서 화면에 보이게 됨 -> 지도에 마커 올림
                
                markers.append(marker) ///새로 만든 마커를 배열에 저장 (나중에 또 싹 지울 때 쓰임)
            }
            // If facilities changed and we haven't fitted the camera yet for this signature, fit bounds once
            if lastFacilitiesSignature != didFitForSignature, !markers.isEmpty {
                // Build bounds by scanning min/max lat/lng (iOS SDK lacks a direct union helper)
                var minLat = markers[0].position.lat
                var minLng = markers[0].position.lng
                var maxLat = markers[0].position.lat
                var maxLng = markers[0].position.lng
                for m in markers.dropFirst() {
                    minLat = min(minLat, m.position.lat)
                    minLng = min(minLng, m.position.lng)
                    maxLat = max(maxLat, m.position.lat)
                    maxLng = max(maxLng, m.position.lng)
                }
                let sw = NMGLatLng(lat: minLat, lng: minLng)
                let ne = NMGLatLng(lat: maxLat, lng: maxLng)
                let bounds = NMGLatLngBounds(southWest: sw, northEast: ne)

                // Use single padding value (CGFloat) per SDK signature; preserve animation safety
                let fitUpdate = NMFCameraUpdate(fit: bounds, padding: 40)
                fitUpdate.animation = .none
                mapView.moveCamera(fitUpdate)
                didFitForSignature = lastFacilitiesSignature
            }
        }
    }
    
}
