//
//  NaverMapViewWrapper.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/29/25.
//

import SwiftUI
import NMapsMap

struct NaverMapViewWrapper: UIViewRepresentable {
    var lat: Double
    var lng: Double
    func makeUIView(context: Context) -> NMFMapView {
        let mapView = NMFMapView()

        let start = SampleRoute.path.first!
        let end = SampleRoute.path.last!
        let center = NMGLatLng(lat: (start.lat + end.lat) / 2, lng: (start.lng + end.lng) / 2)
        let zoom = calculateZoomLevel(start: start, end: end)
        let cameraPosition = NMFCameraPosition(center, zoom: zoom, tilt: 0, heading: 0)
        let cameraUpdate = NMFCameraUpdate(position: cameraPosition)
        mapView.moveCamera(cameraUpdate)

        // ✅ 출발/도착 마커
        addMarker(imageName: "start2", position: SampleRoute.path.first!, mapView: mapView)
        addMarker(imageName: "fin2", position: SampleRoute.path.last!, mapView: mapView)

        // ✅ 휠체어 마커
        for point in SampleRoute.wheelchairPoints {
            addMarker(imageName: "icon1", position: point, mapView: mapView)
        }

        // ✅ 엘리베이터 마커
        for point in SampleRoute.elevatorPoints {
            addMarker(imageName: "icon2", position: point, mapView: mapView)
        }

        // 1. Solid base line (blue-700)
        let pathOverlay = NMFPath()
        pathOverlay.path = NMGLineString(points: SampleRoute.path)
        pathOverlay.width = 15
        pathOverlay.color = UIColor(named: "blue-700") ?? .systemBlue
        pathOverlay.outlineColor = .white
        pathOverlay.outlineWidth = 2
        pathOverlay.patternIcon = NMFOverlayImage(name: "")
        pathOverlay.patternInterval = 30
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
        lat: SampleRoute.path.first!.lat,
        lng: SampleRoute.path.first!.lng
        // zoomLevel 생략해도 자동으로 20!
    )
}
