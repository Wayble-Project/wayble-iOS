//
//  TransportationViewModel.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/13/25.
//

import Foundation

@Observable
class TransportationViewModel {
    var transportation: TransportationModel
    var walkViewModel = WalkViewModel()

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
    
// 스위치 버튼 누르면 출발지 <-> 도착지 바뀜
    func swapLocations() {
        let temp = transportation.departure
        transportation.departure = transportation.destination
        transportation.destination = temp
    }

    // 대중교통, 도보로 넘어감
    func setTab(to tab: TransportationTab) {
        transportation.selectedTab = tab
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
}
    

