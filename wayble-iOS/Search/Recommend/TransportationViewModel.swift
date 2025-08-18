//
//  TransportationViewModel.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/13/25.
//

import Foundation
import Observation
import CoreLocation

@Observable
class TransportationViewModel {
    var transportation: TransportationModel
    var walkViewModel = WalkViewModel()
    // 도보 최적경로 API 서비스
    let walkingService = WalkingService()
    // 대중교통 API 서비스
    private let transitService = TransitService()
    // 대중교통 상태
    var isTransitLoading: Bool = false
    var transitError: String? = nil
    private(set) var transitNextCursor: String? = nil
    private(set) var transitHasNext: Bool = false

    // 페이지네이션 리셋 (출발/도착 변경 후 첫 페이지 요청 전)
    private func resetTransitPagination() {
        transitNextCursor = nil
        transitHasNext = false
    }

    init() {
        self.transportation = TransportationModel(
            departure: "서울시 마포구 와우산로 94",
            destination: "카페 아임히어",
            selectedTab: .transit
        )
    }
    
    // 추천 경로 더미 데이터 예시 추가
    func loadMockRoutes() {
        let route1 = RouteOption(
            totalTime: 45,
            arrivalTime: "오후 2:30 도착",
            cost: 1450,
            steps: [
                RouteStep(type: .subway, title: "출발", subTitle: transportation.departure, detail: nil, extra: nil, Info: nil, extraBus: nil, busTime: nil, role: .start, isFinal: false, routeDetail: "공덕역 5번 출구까지", routeMeter: "도보 30m",simple: false),
                RouteStep(type: .subway, title: "6호선", subTitle: "상수역", detail: "엘리베이터 있음", extra: "14:56", Info: "응암행(광흥창역 방면)", extraBus: nil, busTime: nil, role: .subway, isDeparture: true, chair: "휠체어 전용석 6-1, 10-4", toilet: "장애인 화장실 O",elevator: "엘리베이터와 가까운 승강장 8-1", simple: true),
                RouteStep(type: .subway, title: "6호선", subTitle: "공덕역", detail: nil, extra: nil, Info: nil,busTime: nil,role: .subwayStop, isFinal : true, routeDetail: "공덕역 5번 출구까지", routeMeter: "도보 30m",simple: false),
                RouteStep(type: .bus, title: "마포09", subTitle: "신촌오거리", detail: nil, extra: nil, Info: nil, extraBus: "저상버스", busTime: "배차간격 14분",role: .bus, isDeparture: true, transfer: ["마포16", "마포08"], simple: true, bustitle: "마을"),
                RouteStep(type: .walk, title: "도착", subTitle:"홍대정문", detail: nil, extra: nil, Info: nil, extraBus: nil, busTime: nil, simple: true, showDest: true),
                RouteStep(type: .bus, title: "마을", subTitle: "꿈나무종합타운", detail: nil, extra: nil, Info: nil, extraBus: nil, busTime: nil,role: .finalBusStop, isFinal : true, routeDetail: "공덕역 5번 출구까지", routeMeter: "도보 30m", simple: false),
                RouteStep(type: .walk, title: "도착", subTitle: transportation.destination, detail: nil, extra: nil, Info: nil, extraBus: nil, busTime: nil, role: .destination,destFinal : true, simple: false)
                
            ]
        )
        
        let route2 = RouteOption(
                totalTime: 47,
                arrivalTime: "오후 2:32 도착",
                cost: 1350,
                steps: [
                    RouteStep(type: .subway, title: "6호선", subTitle: "상수역", detail: "엘리베이터 있음", extra: "14:56", Info: "응암행(광흥창역 방면)", extraBus: nil, busTime: nil,simple: true),
                    RouteStep(type: .bus, title: "마포09", subTitle: "신촌오거리", detail: nil, extra: nil, Info: nil, extraBus: "저상버스", busTime: "14분 간격",simple: true),
                    RouteStep(type: .walk, title: "도착", subTitle:"홍대정문", detail: nil, extra: nil, Info: nil, extraBus: nil, busTime: nil,simple: true)
                ]
            )
        
        transportation.recommendedRoutes = [route1,route2]
        // [API 연동 시]
            // 백엔드에서 받은 recommendedRoutes 배열을 그대로 넣기
            // 예시:
            // transportation.recommendedRoutes = response.routes
        
    }
    
    // MARK: - Transit helpers
    
    /// 문자열 좌표 안전 파싱
    private func parseCoord(_ s: String?) -> Double? {
        guard let s = s?.trimmingCharacters(in: .whitespacesAndNewlines), !s.isEmpty else { return nil }
        // 소수점 구분자/단위 문자 등 방어적 제거
        let normalized = s
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: "°", with: "")
        return Double(normalized)
    }

    /// PlaceModel → TransitRequest.PlacePoint 로 변환 (방어적 파싱 + 스왑 감지 + 네이버 스케일 보정)
    private func makePlacePoint(from place: PlaceModel) throws -> TransitRequest.PlacePoint {
        let rawX = place.x
        let rawY = place.y
        print("[makePlacePoint][raw] title=\(place.title) x=\(rawX ?? "nil") y=\(rawY ?? "nil")")

        guard var lng = parseCoord(rawX), var lat = parseCoord(rawY) else {
            throw NSError(domain: "Transit", code: -10,
                          userInfo: [NSLocalizedDescriptionKey: "좌표 파싱 실패 (x=\(rawX ?? "nil"), y=\(rawY ?? "nil"))"])
        }

        // ✅ 네이버 지도 스케일 보정 (1e7 단위) — 값이 비정상적으로 큰 경우 자동으로 나눔
        if abs(lat) > 1000 { lat /= 1e7 }
        if abs(lng) > 1000 { lng /= 1e7 }

        // lat 범위 초과 & lng는 위도 범위에 있으면 스왑 의심 → 교환
        if abs(lat) > 90, abs(lng) <= 90 {
            print("[makePlacePoint] swap lat/lng because lat=\(lat), lng=\(lng)")
            swap(&lat, &lng)
        }

        // 최종 범위 검증
        guard abs(lat) <= 90, abs(lng) <= 180 else {
            throw NSError(domain: "Transit", code: -11,
                          userInfo: [NSLocalizedDescriptionKey: "좌표 범위 오류 (lat=\(lat), lng=\(lng))"])
        }

        let name = place.title.isEmpty ? (place.roadAddress ?? "-") : place.title
        print("[makePlacePoint] name=\(name) lat=\(lat), lng=\(lng)")
        return TransitRequest.PlacePoint(name: name, latitude: lat, longitude: lng)
    }
    
    /// 아주 단순한 HTML 태그 제거 (서버에서 <b>...</b> 등 내려오는 케이스)
    private func stripHTML(_ s: String) -> String {
        return s.replacingOccurrences(of: "<b>", with: "")
                .replacingOccurrences(of: "</b>", with: "")
    }

    /// 백엔드 TransitResponse → 앱의 RouteOption 으로 가볍게 매핑
    /// 서버 스펙에 총 소요시간/도착시각/요금이 있다면 추후 채워주세요.
    /// 백엔드 TransitResponse → 앱의 RouteOption 으로 가볍게 매핑
    private func mapTransit(_ resp: TransitResponse) -> RouteOption {
        // routeIndex 가장 작은 경로 우선
        let chosenRoute: TransitRoute? =
            resp.routes.sorted { (lhs, rhs) in
                (lhs.routeIndex ?? Int.max) < (rhs.routeIndex ?? Int.max)
            }.first ?? resp.routes.first

        let stepsData: [TransitStep] = chosenRoute?.steps ?? []

        let steps: [RouteStep] = stepsData.map { s in
            let from = stripHTML(s.from)
            let to = stripHTML(s.to)
            let sub = "\(from) → \(to)"
            let stops = (s.moveInfo ?? []).map { $0.nodeName }
            let count = s.moveNumber

            switch s.mode {
            case .WALK:
                return RouteStep(
                    type: .walk,
                    title: "도보",
                    subTitle: sub,
                    detail: nil, extra: nil, Info: nil,
                    extraBus: nil, busTime: nil,
                    simple: true, stops: nil, moveCount: nil
                )

            case .SUBWAY:
                let hasElev = (s.subwayInfo?.elevator?.isEmpty == false)
                let detail = hasElev ? "엘리베이터 있음" : nil
                let name = (s.routeName?.isEmpty == false) ? s.routeName! : "지하철"

                let chairInfo: String? = {
                        if let arr = s.subwayInfo?.wheelchair, !arr.isEmpty {
                            return arr.joined(separator: ", ")   // ex) ["6-1", "10-4"] → "6-1, 10-4"
                        }
                        return nil
                    }()
                    let elevatorInfo: String? = {
                        if let arr = s.subwayInfo?.elevator, !arr.isEmpty {
                            return arr.joined(separator: ", ")   // ex) ["8-1"] → "8-1"
                        }
                        return nil
                    }()
                    let restroomInfo: String = (s.subwayInfo?.accessibleRestroom == true) ? "O" : "X"
                
                
                return RouteStep(
                    type: .subway,
                    title: name,
                    subTitle: sub,
                    detail: detail,
                    extra: nil,
                    Info: s.routeName,
                    extraBus: nil,
                    busTime: nil,
                    chair: chairInfo,
                    toilet: restroomInfo,
                    elevator: elevatorInfo,
                    simple: true,
                    stops: stops,
                    moveCount: count
                )

            case .BUS:
                let isLow = (s.busInfo?.isLowFloor?.first == true) //저상버스
                let extraBus = isLow ? "저상버스" : nil
                let dispatch = s.busInfo?.dispatchInterval
                let busTime = (dispatch != nil) ? "배차간격 \(dispatch!)분" : nil
                let name = (s.routeName?.isEmpty == false) ? s.routeName! : "버스"

                return RouteStep(
                    type: .bus,
                    title: name,
                    subTitle: sub,
                    detail: nil,
                    extra: nil,
                    Info: nil,
                    extraBus: extraBus,
                    busTime: busTime,
                    simple: true,
                    stops: stops,
                    moveCount: count
                )
            }
        }

        return RouteOption(totalTime: 0, arrivalTime: "-", cost: 0, steps: steps)
    }
    
    // MARK: - Transit fetchers (첫 페이지/다음 페이지)
    
    /// 첫 페이지 조회: 기존 추천경로를 대체
    @MainActor
    func fetchTransitFirst(departure dep: PlaceModel, arrival arr: PlaceModel, pageSize: Int = 5) async {
        isTransitLoading = true
        transitError = nil
        resetTransitPagination()
        defer { isTransitLoading = false }

        do {
            let origin = try makePlacePoint(from: dep)
            let destination = try makePlacePoint(from: arr)

            let resp = try await transitService.fetchFirst(origin: origin, destination: destination, size: pageSize)

            transitNextCursor = resp.pageInfo.nextCursor?.asString
            transitHasNext = resp.pageInfo.hasNext

            // ✅ 여기!
            transportation.applyTransit(response: resp)
        } catch {
            transitError = error.localizedDescription
        }
    }

    @MainActor
    func fetchTransitNext(departure dep: PlaceModel, arrival arr: PlaceModel, pageSize: Int = 5) async {
        guard transitHasNext, let cursor = transitNextCursor else { return }
        isTransitLoading = true
        transitError = nil
        defer { isTransitLoading = false }

        do {
            let origin = try makePlacePoint(from: dep)
            let destination = try makePlacePoint(from: arr)

            // cursor 문자열→Int 변환은 네가 이미 처리했으니 그대로
            let resp = try await transitService.fetchNext(origin: origin, destination: destination, cursor: Int(cursor), size: pageSize)

            transitNextCursor = resp.pageInfo.nextCursor?.asString
            transitHasNext = resp.pageInfo.hasNext

            // 기존 목록 뒤에 추가
            let old = transportation.recommendedRoutes
            transportation.applyTransit(response: resp)
            transportation.recommendedRoutes = old + transportation.recommendedRoutes
        } catch {
            transitError = error.localizedDescription
        }
    }
    
// 스위치 버튼 누르면 출발지 <-> 도착지 바뀜
    func swapLocations() {
        let temp = transportation.departure
        transportation.departure = transportation.destination
        transportation.destination = temp
    }

    /// 도보 경로 재요청: WalkViewModel 로 위임 (서비스 호출까지 내부에서 처리)
    @MainActor
    func fetchWalkingRoute(departure: PlaceModel, arrival: PlaceModel) async {
        await walkViewModel.loadWalkingRoute(departure: departure, arrival: arrival)
    }

    // 대중교통, 도보로 넘어감
    func setTab(to tab: TransportationTab) {
        transportation.selectedTab = tab
    }
    
    @MainActor
    func resetTransit() {
        transitError = nil
        isTransitLoading = false
        transitHasNext = false
        transitNextCursor = nil
        transportation.recommendedRoutes = []
    }
    // 출발지 또는 도착지 설정
    func setPlace(_ place: PlaceModel, for entryType: EntryType) {
        switch entryType {
        case .departure:
            transportation.departure = place.roadAddress
        case .destination:
            transportation.destination = place.roadAddress
        }
    }
    // 요약된 previewSteps만 추출 (RouteView 용)
    var previewRoutes: [RouteOption] {
        return transportation.recommendedRoutes.map { route in
            let filteredSteps = route.steps.filter { step in
                // 출발/도착/중간하차에 해당하지 않는 것만 보여주기
                return !(step.title.contains("출발") || step.isFinal == true || step.destFinal == true)
            }
            return RouteOption(
                totalTime: route.totalTime,
                arrivalTime: route.arrivalTime,
                cost: route.cost,
                steps: filteredSteps
            )
        }
    }
    
    // MARK: - Convenience
    /// 대중교통 탭으로 전환하며 첫 페이지를 불러옵니다.
    @MainActor
    func showTransitAndLoad(dep: PlaceModel, arr: PlaceModel) async {
        setTab(to: .transit)
        await fetchTransitFirst(departure: dep, arrival: arr)
    }
}
