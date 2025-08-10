//
//  WalkViewModel.swift
//  wayble-iOS
//
//  Created by 신민정 on 8/2/25.
//

import Foundation
import SwiftUI
import NMapsMap

@Observable
class WalkViewModel {
    var routes: [RouteData] = [SampleRoutes.shortest, SampleRoutes.wayble]
    var selectedRoute: RouteData = SampleRoutes.wayble

    var mapRefreshTrigger = UUID()
    var isLoading = false
    var apiError: String? = nil

    private let walkingService = WalkingService()

    func selectRoute(_ route: RouteData) {
        selectedRoute = route
        mapRefreshTrigger = UUID()
    }

    // 네이버 local x/y가 1e7 스케일일 수 있으므로 자동 보정
    private func normalize(_ v: Double) -> Double { v > 1000 ? v / 1e7 : v }

    // 실패 시 공통 정리
    private func clearRouteAndRefresh() {
        self.selectedRoute = RouteData(
            title: "",
            time: "",
            arrivalTime: "",
            distance: "",
            path: [],
            elevatorPoints: nil,
            wheelchairPoints: nil,
            lineColor: .gray
        )
        self.routes = []
        self.mapRefreshTrigger = UUID()
    }

    @MainActor
    func loadWalkingRoute(departure: PlaceModel, arrival: PlaceModel) async {
        // PlaceModel: x=lng, y=lat (네이버 local x/y는 1e7 스케일일 수 있어 보정)
        guard
            let sLatRaw = Double(departure.y ?? ""),
            let sLngRaw = Double(departure.x ?? ""),
            let eLatRaw = Double(arrival.y ?? ""),
            let eLngRaw = Double(arrival.x ?? "")
        else {
            apiError = "출발/도착 좌표가 올바르지 않아요."
            return
        }

        let sLat = normalize(sLatRaw)
        let sLng = normalize(sLngRaw)
        let eLat = normalize(eLatRaw)
        let eLng = normalize(eLngRaw)

        // 백엔드 명세: startName / endName 필수 (HTML 태그 제거)
        let startName = departure.title.removeHTMLTags()
        let endName   = arrival.title.removeHTMLTags()

        // 위·경도 범위 검증
        guard (-90...90).contains(sLat), (-90...90).contains(eLat),
              (-180...180).contains(sLng), (-180...180).contains(eLng) else {
            apiError = "좌표 범위가 잘못됐어요."
            clearRouteAndRefresh()
            return
        }

        isLoading = true
        apiError = nil
        defer { isLoading = false }

        do {
            print("🚀 Walking API 요청 → s(\(sLat), \(sLng)) → e(\(eLat), \(eLng))  | query: startX=\(sLng)&startY=\(sLat)&endX=\(eLng)&endY=\(eLat)&startName=\(startName)&endName=\(endName)")
            let res = try await walkingService.fetchWalkingRoute(
                startX: sLng, startY: sLat,
                endX: eLng, endY: eLat,
                startName: startName, endName: endName
            )
            if let data = res.data {
                // 빈 경로 방어: steps에 좌표가 하나도 없으면 실패 처리
                if !data.hasPolyline {
                    apiError = "경로를 찾을 수 없습니다. (빈 경로)"
                    clearRouteAndRefresh()
                    return
                }

                // 로그는 새 필드 사용
                print("✅ Walking API 성공 - distance:\(data.totalDistance) time:\(data.totalTime)")

                let route = data.toRouteData()
                self.routes = [route]
                self.selectedRoute = route
                self.mapRefreshTrigger = UUID()
            } else {
                apiError = "[\(res.errorCode ?? -1)] \(res.message ?? "경로를 찾을 수 없습니다.")"
                clearRouteAndRefresh()
            }
        } catch {
            apiError = error.localizedDescription
            clearRouteAndRefresh()
        }
    }
}
