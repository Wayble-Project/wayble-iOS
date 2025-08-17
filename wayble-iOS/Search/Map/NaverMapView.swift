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

    //마커 기준으로 카메라를 살짝 치우칠지 여부 + 오프셋 값
    var keepOffsetToMarker: Bool = false
    var cameraLngOffset: Double = -0.000019

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: Context) -> NMFMapView {
        let mapView = NMFMapView()
        mapView.minZoomLevel = 5.0
        mapView.maxZoomLevel = 21.0
        mapView.isZoomGestureEnabled = true

        // ✅ 초기 카메라 위치: 옵션에 따라 오프셋 적용
        let cameraLat = centerY
        let cameraLng = centerX + (keepOffsetToMarker ? cameraLngOffset : 0.0)
        let cameraPosition = NMFCameraPosition(
            NMGLatLng(lat: cameraLat, lng: cameraLng),
            zoom: zoomLevel
        )
        mapView.moveCamera(NMFCameraUpdate(position: cameraPosition))
        mapView.addCameraDelegate(delegate: context.coordinator)

        // (선택) 상단/하단 UI가 가릴 때 보이는 중심 보정용
        // mapView.contentInset = UIEdgeInsets(top: 84, left: 0, bottom: 120, right: 0)

        /// 초기/변경 시마다 갱신
        context.coordinator.renderMarkers(on: mapView, facilities: facilities)

        if showMarker {
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: centerY, lng: centerX)

            // 안전한 에셋 로딩 + 폴백
            if let img = UIImage(named: "pin11") {
                marker.iconImage = NMFOverlayImage(image: img)
            } else {
                print("⚠️ [Map] 'pin11' asset not found or not in target. Fallback to default.")
                marker.iconImage = NMF_MARKER_IMAGE_BLUE
            }

            // 충돌로 인한 자동 숨김 방지 + 위로 올리기
            marker.isHideCollidedSymbols = false
            marker.isHideCollidedCaptions = false
            marker.zIndex = 10_000

            marker.width = 46
            marker.height = 58.78
            marker.anchor = CGPoint(x: 0.5, y: 1.0)
            marker.mapView = mapView
        }

        return mapView
    }

    func updateUIView(_ uiView: NMFMapView, context: Context) {
        //  centerX/Y가 바뀐 경우에만 카메라 이동
        DispatchQueue.main.async {
            let changed =
                context.coordinator.lastCenterX != self.centerX ||
                context.coordinator.lastCenterY != self.centerY

            if changed {
                let target = NMGLatLng(lat: self.centerY, lng: self.centerX)
                let update = NMFCameraUpdate(scrollTo: target) // zoom 유지
                context.coordinator.isProgrammaticMove = true
                uiView.moveCamera(update)
                context.coordinator.lastCenterX = self.centerX
                context.coordinator.lastCenterY = self.centerY

                // place가 바뀌었으니 오프셋 1회 재적용을 허용하려면 서명 초기화
                context.coordinator.lastAppliedPlaceSignature = nil
            }

            //  facilities가 비어도 호출해서 기존 마커 정리되게
            context.coordinator.renderMarkers(on: uiView, facilities: facilities)
        }
    }

    class Coordinator: NSObject, NMFMapViewCameraDelegate {
        var parent: NaverMapView

        // 루프 방지 / 변경 감지
        var isProgrammaticMove = false
        var lastCenterX: Double?
        var lastCenterY: Double?

        // 같은 place(centerX/Y)에 대해 오프셋을 이미 적용했는지 저장
        var lastAppliedPlaceSignature: String?

        private var markers: [NMFMarker] = []
        private var lastFacilitiesSignature: String?
        private var didFitForSignature: String?

        init(_ parent: NaverMapView) {
            self.parent = parent
        }

        func mapViewCameraIdle(_ mapView: NMFMapView) {
            let center = mapView.cameraPosition.target

            // 내가 움직였던 카메라면 플래그만 내리고 종료(루프 방지)
            if isProgrammaticMove {
                isProgrammaticMove = false
            }

            // 상위로 현재 카메라 좌표 보고
            DispatchQueue.main.async {
                self.parent.onLocationChanged?(center.lat, center.lng)
            }

            //  옵션: 오프셋 유지 모드일 때 마커 기준으로 카메라를 살짝 치우치게
            guard parent.keepOffsetToMarker else { return }

            let target = NMGLatLng(lat: parent.centerY, lng: parent.centerX + parent.cameraLngOffset)

            // 같은 place에 대해 이미 맞췄고 현재도 거의 같으면 스킵
            let placeSig = "\(parent.centerX),\(parent.centerY)"
            if lastAppliedPlaceSignature == placeSig && approximatelyEqual(center, target) {
                return
            }

            // 카메라 이동 (애니메이션 없이, 루프 방지)
            isProgrammaticMove = true
            let update = NMFCameraUpdate(position: NMFCameraPosition(target, zoom: parent.zoomLevel))
            update.animation = .none
            mapView.moveCamera(update)
            lastAppliedPlaceSignature = placeSig
        }

        private func approximatelyEqual(_ a: NMGLatLng, _ b: NMGLatLng, eps: Double = 1e-7) -> Bool {
            abs(a.lat - b.lat) < eps && abs(a.lng - b.lng) < eps
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
        func renderMarkers(on mapView: NMFMapView, facilities: [HomeFacility]) {
            // 비었을 때는 기존 마커 정리하고 종료
            if facilities.isEmpty {
                for marker in markers { marker.mapView = nil }
                markers.removeAll()
                lastFacilitiesSignature = nil
                didFitForSignature = nil
                return
            }

            // Build a lightweight change signature to avoid re-rendering identical markers
            let signature: String = facilities.map { f in
                "\(String(format: "%.6f", f.latitude)),\(String(format: "%.6f", f.longitude)),\(f.facilityType.uppercased())"
            }.joined(separator: "|")

            if signature == lastFacilitiesSignature {
                // No change in facilities; skip heavy re-render to prevent loops/log spam
                return
            }
            lastFacilitiesSignature = signature

            print("[Map] facilities.count = \(facilities.count)")

            /// 기존 마커 제거
            for marker in markers { marker.mapView = nil }
            markers.removeAll()

            /// 새 마커 생성
            for f in facilities {
                let marker = NMFMarker()
                marker.position = NMGLatLng(lat: f.latitude, lng: f.longitude)
                marker.isHideCollidedSymbols = false
                marker.isHideCollidedCaptions = false
                print("[Map] marker lat=\(f.latitude), lng=\(f.longitude)")

                let style = markerStyle(for: f.facilityType)
                if let uiImage = UIImage(named: style.iconName) {
                    marker.iconImage = NMFOverlayImage(image: uiImage)
                } else {
                    marker.iconImage = NMF_MARKER_IMAGE_BLUE
                }
                marker.width = style.width
                marker.height = style.height
                marker.anchor = CGPoint(x: 0.5, y: 1.0)
                marker.zIndex = 1000
                marker.mapView = mapView
                markers.append(marker)
            }

            // 최초 1회 bounds fit
            if lastFacilitiesSignature != didFitForSignature, !markers.isEmpty {
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

                let fitUpdate = NMFCameraUpdate(fit: bounds, padding: 40)
                fitUpdate.animation = .none
                mapView.moveCamera(fitUpdate)
                didFitForSignature = lastFacilitiesSignature
            }
        }
    }
}
