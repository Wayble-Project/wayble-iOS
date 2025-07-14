//
//  TransportationModel.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/13/25.
//

import Foundation
import Observation
import SwiftUI

@Observable
class TransportationModel {
    var departure: String
    var destination: String
    var selectedTab: TransportationTab
    
    var recommendedRoutes: [RouteOption] = []  //추천경로 리스트들 (모음집)
    
    init(
        departure: String = "서울시 마포구 와우산로 94",
        destination: String = "카페 아임히어",
        selectedTab: TransportationTab = .transit
    ) {
        self.departure = departure
        self.destination = destination
        self.selectedTab = selectedTab
    }
}

class RouteOption: Identifiable {
    let id = UUID()
    let totalTime: Int            // ex: 45 (분)
    let arrivalTime: String       // ex: "오후 2:30 도착"
    let cost: Int                 // ex: 1450 (원)
    let steps: [RouteStep]        // 경로 단계들 (지하철, 버스, 도보 등)
    
    init(totalTime: Int, arrivalTime: String, cost: Int, steps: [RouteStep]) {
            self.totalTime = totalTime
            self.arrivalTime = arrivalTime
            self.cost = cost
            self.steps = steps
        }
}

// 경로의 각 단계
class RouteStep: Identifiable {
    let id = UUID()
    let type: RouteStepType       // subway / bus / walk
    let title: String             // ex: "2호선"
    let subTitle: String         // ex: "상수역"
    let detail: String?           // ex: "엘리베이터 있음"
    let extra : String?        // ex: "14:56"
    let Info: String?        // ex: "응암행"
    let extraBus : String? // ex: "저상버스"
    let busTime : String? // ex: "배차간격 14분"
    var subwayLine: SubwayLine? // 지하철 색깔 표시, 버스면 nil로 표시
    var busType: BusType?         // 버스 색깔 표시
    
    init(type: RouteStepType, title: String, subTitle: String, detail: String? = nil, extra: String? = nil, Info: String? = nil, extraBus: String? = nil, busTime: String?) {
        self.type = type
        self.title = title
        self.subTitle = subTitle
        self.detail = detail
        self.extra = extra
        self.Info = Info
        self.extraBus = extraBus
        self.busTime = busTime
        
        
        
        var subwayLine: SubwayLine? = nil
        let busType: BusType? = nil

        switch type {
        case .subway:
                let lineName = title.components(separatedBy: " ").first ?? ""
                self.subwayLine = SubwayLine(rawValue: lineName)
                self.busType = nil
        case .bus:
            self.subwayLine = nil
            if title.contains("마을") || title.contains("마포") {
                self.busType = .마을버스
            } else {
                self.busType = .간선버스
            }

            /*
             백엔드가
             {
               "type": "bus",
               "title": "마포09",
               "busType": "마을버스",
               ...
             }
             
             이렇게 주면
             self.busType = BusType(rawValue: json["busType"])
             이렇게 설정합니당 */
            
            //일단 연동전이니까 임시로 해둠! 

            
        case .walk:
            break
        }

    }
}

enum RouteStepType {
    case subway, bus, walk
}

enum TransportationTab: String, CaseIterable {
    case transit = "대중교통"
    case walking = "도보"
}

// 1.디자이너에게 색깔받기 2.케이스 늘어나면 추가하기
enum BusType: String {
    case 마을버스
    case 간선버스
    
    var color: Color {
        switch self {
        case .마을버스:
            return Color.bus1
        case .간선버스:
            return Color.bus2
        }
    }
}

enum SubwayLine: String {
    case line1 = "1호선"
    case line2 = "2호선"
    case line3 = "3호선"
    case line4 = "4호선"
    case line5 = "5호선"
    case line6 = "6호선"
    case line7 = "7호선"
    case line8 = "8호선"
    case line9 = "9호선"

    
    // 지하철 호선별로 컬러 디자이너에게 받기
    var color: Color {
        switch self {
        case .line1: return Color.line1
        case .line2: return Color.line2
        case .line3: return Color.line3
        case .line4: return Color.line4
        case .line5: return Color.line5
        case .line6: return Color.line6
        case .line7: return Color.line7
        case .line8: return Color.line8
        case .line9: return Color.line9
        }
    }
}
