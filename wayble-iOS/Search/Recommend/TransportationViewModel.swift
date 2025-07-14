//
//  TransportationViewModel.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/13/25.
//

import Foundation
import Combine

final class TransportationViewModel: ObservableObject {
    var transportation: TransportationModel

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
                RouteStep(type: .subway, title: "6호선", subTitle: "상수역", detail: "엘리베이터 있음", extra: "14:56", Info: "응암행(광흥창역 방면)", extraBus: nil, busTime: nil),
                RouteStep(type: .bus, title: "마포09", subTitle: "신촌오거리", detail: nil, extra: nil, Info: nil, extraBus: "저상버스", busTime: "배차간격 14분"),
                RouteStep(type: .walk, title: "도착", subTitle:"홍대정문", detail: nil, extra: nil, Info: nil, extraBus: nil, busTime: nil)
            ]
        )
        
        let route2 = RouteOption(
                totalTime: 47,
                arrivalTime: "오후 2:32 도착",
                cost: 1350,
                steps: [
                    RouteStep(type: .subway, title: "6호선", subTitle: "상수역", detail: "엘리베이터 있음", extra: "14:56", Info: "응암행(광흥창역 방면)", extraBus: nil, busTime: nil),
                    RouteStep(type: .bus, title: "마포09", subTitle: "신촌오거리", detail: nil, extra: nil, Info: nil, extraBus: "저상버스", busTime: "14분 간격"),
                    RouteStep(type: .walk, title: "도착", subTitle:"홍대정문", detail: nil, extra: nil, Info: nil, extraBus: nil, busTime: nil)
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
}
