//
//  TransitResponse.swift
//  wayble-iOS
//
//  Created by 신민정 on 8/14/25.
//

import Foundation

// ---------- 서버 응답 전체(envelope) ----------
struct TransitEnvelope: Decodable {
    let data: TransitPayload
}

// ---------- 실제 payload ----------
struct TransitPayload: Decodable {
    let routes: [TransitRoute]
    let pageInfo: PageInfo
}

// 개별 경로
struct TransitRoute: Decodable {
    let routeIndex: Int?
    let steps: [TransitStep]
}

// 한 구간(step)
struct TransitStep: Decodable {
    let mode: TransitMode                // "WALK" | "SUBWAY" | "BUS"
    let routeName: String?               // BUS: 버스 번호, SUBWAY: 호선명 (nullable)
    let moveNumber: Int                  // 건너뛴 역/정류장 개수
    let moveInfo: [MoveNode]?            // 건너뛴 역/정류장 리스트 (nullable)
    let busInfo: BusInfo?                // BUS일 때만 존재
    let subwayInfo: SubwayInfo?          // SUBWAY일 때만 존재
    let from: String                     // 시작 역/정류장
    let to: String                       // 도착 역/정류장
}

enum TransitMode: String, Decodable {
    case WALK, SUBWAY, BUS
}

struct MoveNode: Decodable {
    let nodeName: String
}

struct BusInfo: Decodable {
    let isShuttleBus: Bool
    let isLowFloor: [Bool]?              // 빈 배열/누락 모두 대응
    let dispatchInterval: Int?           // null 가능
}

struct SubwayInfo: Decodable {
    let wheelchair: [String]?          // []
    let elevator: [String]?            // []
    let accessibleRestroom: Bool?        // null 가능
    
}

struct GeoPoint: Codable {
    let latitude: Double
    let longitude: Double
}

struct PageInfo: Decodable {
    let nextCursor: CursorValue?
    let hasNext: Bool
}

// 숫자/문자열 커서 모두 수용
enum CursorValue: Decodable {
    case string(String)
    case int(Int)

    init(from decoder: Decoder) throws {
        let c = try decoder.singleValueContainer()
        if let s = try? c.decode(String.self) { self = .string(s); return }
        if let i = try? c.decode(Int.self)    { self = .int(i);    return }
        throw DecodingError.typeMismatch(
            CursorValue.self,
            .init(codingPath: decoder.codingPath,
                  debugDescription: "Expected string or int cursor")
        )
    }

    var asString: String? {
        switch self {
        case .string(let s): return s
        case .int(let i):    return String(i)
        }
    }
}

// 기존 코드와 호환을 위해 별칭 제공
typealias TransitResponse = TransitPayload
