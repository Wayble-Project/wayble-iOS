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
    
    func makeCoordinator() -> Coordinator {
            Coordinator(self)
        }

    
    func makeUIView(context: Context) -> NMFMapView {
        let mapView = NMFMapView()
        let cameraPosition = NMFCameraPosition(
            NMGLatLng(lat: centerY, lng: centerX),
            zoom: 20
        )
        mapView.moveCamera(NMFCameraUpdate(position: cameraPosition))
        return mapView
    }
    
    func updateUIView(_ uiView: NMFMapView, context: Context) {
        // 업데이트 시 지도 다시 이동 가능
        let cameraPosition = NMFCameraPosition(
            NMGLatLng(lat: centerY, lng: centerX),
            zoom: 19
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
