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
    private let waybleWalkService = WaybleWalkService()   // ✅ 웨이블 추가

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

    // 웨이블 polyline → NMGLatLng 변환 (lat/lon 뒤바뀌어 와도 안전하게 처리)
    private func mapPolylineToLatLng(_ raw: [[Double]]) -> [NMGLatLng] {
        raw.compactMap { pair in
            guard pair.count >= 2 else { return nil }
            let a = pair[0], b = pair[1]
            // 위도는 ±90, 경도는 ±180 → 순서 감지해서 스왑
            let (lat, lng): (Double, Double) = (abs(a) <= 90 && abs(b) <= 180) ? (a, b) : (b, a)
            return NMGLatLng(lat: lat, lng: lng)
        }
    }

    private func formatMinutes(_ seconds: Int) -> String {
        let m = seconds / 60, s = seconds % 60
        return s == 0 ? "\(m)분" : "\(m)분 \(s)초"
    }


    private func formatArrival(after seconds: Int) -> String {
        let target = Date().addingTimeInterval(TimeInterval(seconds))
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_KR")
        f.dateFormat = "a HH:mm 도착"
        return f.string(from: target)
    }


    
    
    private func formatDistance(_ meters: Int) -> String {
        if meters >= 1000 {
            return String(format: "%.1fkm", Double(meters) / 1000.0)
        } else {
            return "\(meters)m"
        }
    }
    
    
    

    /// 서버의 WaybleWalkResponse.Data → RouteData로 변환 (Response 정의는 건드리지 않음)
    private func toWaybleRouteData(_ data: WalkData) -> RouteData {
        let path = mapPolylineToLatLng(data.polyline)

        // points: RAMP → wheelchair, ELEVATOR → elevator
        var wheelchair: [NMGLatLng] = []
        var elevator: [NMGLatLng] = []
        
            for p in data.points {
                // p.type 이 String이든 enum이든 안전하게 문자열로 비교
                switch String(describing: p.type).uppercased() {
                case "RAMP":
                    wheelchair.append(NMGLatLng(lat: p.lat, lng: p.lon))
                case "ELEVATOR":
                    elevator.append(NMGLatLng(lat: p.lat, lng: p.lon))
                default:
                    break
                }
            }
        
        return RouteData(
            title: "웨이블 추천거리",
            time: formatMinutes(data.time),
            arrivalTime: formatArrival(after: data.time),
            distance: formatDistance(data.distance),
            path: path,
            elevatorPoints: elevator.isEmpty ? nil : elevator,
            wheelchairPoints: wheelchair.isEmpty ? nil : wheelchair,
            lineColor: (UIColor(named: "blue-700") ?? .systemBlue)
        )
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
            print("🚀 Walking API 요청 → s(\(sLat), \(sLng)) → e(\(eLat), \(eLng))")
            print("    query: startX=\(sLng)&startY=\(sLat)&endX=\(eLng)&endY=\(eLat)&startName=\(startName)&endName=\(endName)")

            // 1) 최단 경로
            let shortestRes = try await walkingService.fetchWalkingRoute(
                startX: sLng, startY: sLat,
                endX: eLng, endY: eLat,
                startName: startName, endName: endName
            )

            var list: [RouteData] = []

            if let d = shortestRes.data, d.hasPolyline {
                print("✅ Walking(최단) 성공 - distance:\(d.totalDistance) time:\(d.totalTime)")
                let shortest = d.toRouteData() // 기존 변환기 그대로 사용
                list.append(shortest)
            } else {
                print("⚠️ Walking(최단) 빈 경로")
            }

            // 2) 웨이블 경로 (있으면 추가)
            do {
                let waybleRes = try await waybleWalkService.fetchWaybleWalkRoute(
                    startX: sLng, startY: sLat,
                    endX: eLng, endY: eLat,
                    startName: startName, endName: endName
                )

                if let w = waybleRes.data, w.polyline.count >= 2 {
                    list.append(toWaybleRouteData(w))
                } else {
                    // 에러 바디거나 빈 경로
                    if let code = waybleRes.errorCode, let msg = waybleRes.message {
                        print("ℹ️ Wayble 서버에러 \(code): \(msg)")
                    } else {
                        print("ℹ️ Wayble 데이터 없음/빈 경로")
                    }
                }
            } catch {
                // 웨이블 실패는 치명적 아님 → 로그만 남기고 무시
                print("ℹ️ Wayble(웨이블) 호출 실패: \(error.localizedDescription)")
            }

            guard !list.isEmpty else {
                apiError = "경로를 찾을 수 없습니다."
                clearRouteAndRefresh()
                return
            }

            // 노출: 최단은 항상 포함, 웨이블 있으면 함께 표시
            self.routes = list

            // 선택 정책: 웨이블 있으면 웨이블 선택, 아니면 최단 선택
            if let wayble = list.first(where: { $0.title == "웨이블 경로" }) {
                self.selectedRoute = wayble
            } else {
                self.selectedRoute = list[0]
            }

            self.mapRefreshTrigger = UUID()

        } catch {
            apiError = error.localizedDescription
            clearRouteAndRefresh()
        }
    }
}
