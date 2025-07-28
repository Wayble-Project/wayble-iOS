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
    
    
    func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

    
    func makeUIView(context: Context) -> NMFMapView {
        
        let mapView = NMFMapView()
        let cameraLat = centerY
        let cameraLng = centerX + 0.0029
        let cameraPosition = NMFCameraPosition(
            NMGLatLng(lat: cameraLat, lng: cameraLng),
            zoom: zoomLevel
        )
        mapView.moveCamera(NMFCameraUpdate(position: cameraPosition))
        mapView.addCameraDelegate(delegate: context.coordinator)
        
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
        //사용자 입장에서 마커가 가운데에 보이게 !!
        let cameraLat = centerY
        let cameraLng = centerX - 0.000019
        let cameraPosition = NMFCameraPosition(
            NMGLatLng(lat: cameraLat, lng: cameraLng),
            zoom: zoomLevel
        )
        uiView.moveCamera(NMFCameraUpdate(position: cameraPosition))
    }
    class Coordinator: NSObject, NMFMapViewCameraDelegate {
        var parent: NaverMapView
        
        init(_ parent: NaverMapView) {
            self.parent = parent
        }
        
        func mapViewCameraIdle(_ mapView: NMFMapView) {
            let center = mapView.cameraPosition.target
            let adjustedLat = center.lat + 0.0001
            let adjustedLng = center.lng - 0.0001
            parent.onLocationChanged?(adjustedLat, adjustedLng)
        }
    }
    
}
