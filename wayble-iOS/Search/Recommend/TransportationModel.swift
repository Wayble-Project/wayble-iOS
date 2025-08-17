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
    var transitSteps: [RouteStep] = []   // 대중교통 스텝만 저장 (시간/요금 제외)
    
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

class RouteOption: Identifiable, Hashable {
    let id = UUID()
    let totalTime: Int
    let arrivalTime: String
    let cost: Int
    let steps: [RouteStep]
    
    init(totalTime: Int, arrivalTime: String, cost: Int, steps: [RouteStep]) {
        self.totalTime = totalTime
        self.arrivalTime = arrivalTime
        self.cost = cost
        self.steps = steps
    }
    
    // Hashable 구현
    static func == (lhs: RouteOption, rhs: RouteOption) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
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
    var isDeparture: Bool = false
    var isFinal: Bool = false
    var routeDetail: String? //ex:공덕역 5번 출구까지
    var routeMeter: String? // ex: 도보 30m
    var chair: String? //ex: "휠체어 전용석 6-1, 10-4"
    var toilet: String? // ex: "장애인 화장실 O"
    var elevator: String? //ex : "엘리베이터와 가까운 승강장 8-1"
    var transfer: [String]? // ex: 마포16, 마포09 ... 여러개
    var destFinal: Bool = false
    var simple: Bool = false
    var showDest: Bool = false
    var bustitle: String? // 마을
    var role: StepRole? // 각 단계의 역할 정보 (출발, 지하철, 버스환승, 하차 등)
    /// 정류장/역 이름 리스트 (moveInfo)
    let stops: [String]?      // 정류장/역 이름 리스트 (moveInfo)
    /// 건너뛴 개수 표시용 (moveNumber)
    let moveCount: Int?       // 건너뛴 개수 표시용 (moveNumber)
    
    init(
        type: RouteStepType,
        title: String,
        subTitle: String,
        detail: String? = nil,
        extra: String? = nil,
        Info: String? = nil,
        extraBus: String? = nil,
        busTime: String?,
        role: StepRole? = nil,
        isDeparture: Bool = false,
        isFinal: Bool = false,
        routeDetail: String? = nil,
        routeMeter: String? = nil,
        chair: String? = nil,
        toilet: String? = nil,
        elevator: String? = nil,
        transfer: [String]? = nil,
        destFinal: Bool = false,
        simple: Bool = false,
        showDest: Bool = false,
        bustitle: String? = nil,
        stops: [String]? = nil,
        moveCount: Int? = nil
    ) {
        self.type = type
        self.title = title
        self.subTitle = subTitle
        self.detail = detail
        self.extra = extra
        self.Info = Info
        self.extraBus = extraBus
        self.busTime = busTime
        self.role = role
        self.isDeparture = isDeparture
        self.isFinal = isFinal
        self.routeDetail = routeDetail
        self.routeMeter = routeMeter
        self.chair = chair
        self.toilet = toilet
        self.elevator = elevator
        self.transfer = transfer
        self.destFinal = destFinal
        self.simple = simple
        self.showDest = showDest
        self.bustitle = bustitle
        
        self.stops = stops
        self.moveCount = moveCount
        
        
        
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

enum StepRole {
    case start
    case subway
    case bus
    case transferBus
    case subwayStop
    case finalBusStop
    case destination

}

extension TransportationModel {
    /// 서버 응답을 화면용 RouteOption 리스트로 변환해 recommendedRoutes 채움
    func applyTransit(response: TransitResponse) {
        func strip(_ s: String) -> String {
            s.replacingOccurrences(of: "<b>", with: "")
             .replacingOccurrences(of: "</b>", with: "")
        }

        let options: [RouteOption] = response.routes.map { route in
            let steps: [RouteStep] = route.steps.map { s in
                let type: RouteStepType = {
                    switch s.mode {
                    case .WALK:   return .walk
                    case .SUBWAY: return .subway
                    case .BUS:    return .bus
                    }
                }()

                let rawName = s.routeName ?? ""
                let title = rawName.isEmpty
                    ? (type == .walk ? "도보" : (type == .subway ? "지하철" : "버스"))
                    : rawName

                // from → to
                let sub = "\(strip(s.from)) → \(strip(s.to))"

                let detail: String? = {
                    guard let si = s.subwayInfo else { return nil }
                    let lift = si.wheelchair?.count ?? 0
                    let elev = si.elevator?.count ?? 0
                    let toilet = (si.accessibleRestroom == true) ? "O" : "X"
                    return "휠체어 리프트: \(lift)개 / 엘리베이터: \(elev)개 / 장애인 화장실: \(toilet)"
                }()

                let extraBus = (s.busInfo?.isShuttleBus == true) ? "마을버스" : nil
                let busTime  = s.busInfo?.dispatchInterval.map { "배차간격 \($0)분" }
                let isLowFloor  = (s.busInfo?.isLowFloor?.contains(true) == true) ? "저상버스" : nil
                let lowTag: String?  = (isLowFloor != nil) ? "저상버스" : nil
                
                return RouteStep(
                    type: type,
                    title: title,
                    subTitle: sub,
                    detail: detail,
                    extra: nil,
                    Info: lowTag,
                    extraBus: extraBus,
                    busTime: busTime,
                    simple: true,
                    stops: s.moveInfo?.map { $0.nodeName },
                    moveCount: s.moveNumber
                )
            }

            // 총시간/요금/도착시는 서버 스펙 추가되면 채우자
            return RouteOption(totalTime: 0, arrivalTime: "-", cost: 0, steps: steps)
        }

        self.recommendedRoutes = options
        self.transitSteps = [] // 안 쓰면 비워두거나 유지
    }
}
