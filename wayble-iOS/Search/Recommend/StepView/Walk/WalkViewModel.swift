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

    @MainActor
    func loadWalkingRoute(departure: PlaceModel, arrival: PlaceModel) async {
        // PlaceModel: x=lng, y=lat 가정
        guard
            let sLat = Double(departure.y ?? ""),
            let sLng = Double(departure.x ?? ""),
            let eLat = Double(arrival.y ?? ""),
            let eLng = Double(arrival.x ?? "")
        else {
            apiError = "출발/도착 좌표가 올바르지 않아요."
            return
        }

        isLoading = true
        apiError = nil
        defer { isLoading = false }

        do {
            print("🚀 Walking API 요청 → s(\(sLat), \(sLng)) → e(\(eLat), \(eLng))")
            let res = try await walkingService.fetchWalkingRoute(
                startLat: sLat, startLng: sLng, endLat: eLat, endLng: eLng
            )
            if let data = res.data {
                // 빈 경로 방어 로직
                if data.path.isEmpty {
                    apiError = "경로를 찾을 수 없습니다. (path 비어 있음)"
                    // 지도에서 기존 라인을 지우기 위해 빈 라우트로 교체 + 리프레시
                    self.routes = []
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
                    self.mapRefreshTrigger = UUID()
                    return
                }
                print("✅ Walking API 성공 - distance:\(data.distance) duration:\(data.duration) points:\(data.path.count)")
                let route = data.toRouteData()
                self.routes = [route]               // 필요하면 샘플과 비교: [route, SampleRoutes.shortest]
                self.selectedRoute = route
                self.mapRefreshTrigger = UUID()     // NaverMap 래퍼 리프레시
            } else {
                apiError = "[\(res.errorCode ?? -1)] \(res.message ?? "경로를 찾을 수 없습니다.")"
                // 지도 갱신: 실패 시 기존 라인이 남지 않도록 비워줌
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
                self.mapRefreshTrigger = UUID()
                self.routes = []
            }
        } catch {
            apiError = error.localizedDescription
            // 실패 시 지도 선 제거
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
            self.mapRefreshTrigger = UUID()
            self.routes = []
        }
    }
}
