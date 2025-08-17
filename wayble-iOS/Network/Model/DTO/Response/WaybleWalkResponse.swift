//
//  WaybleWalkResponse.swift
//  wayble-iOS
//
//  Created by 신민정 on 8/17/25.
//

import Foundation
import CoreLocation

// MARK: - 공통 도메인 모델 (UI/그리기에서 이 타입만 사용)
struct WaybleWalk {
    let distanceMeters: Int
    let durationSeconds: Int
    let path: [CLLocationCoordinate2D]    // 경로 폴리라인
    let markers: [Marker]                 // 웨이블존 마커(노션 응답 전용)
    let points: [Point]                   // 스웨거 points(스웨거 응답 전용)

    struct Marker {
        let type: String
        let lat: Double
        let lng: Double
    }

    struct Point {
        let type: String?
        let lat: Double
        let lng: Double
    }
}

// =============================================================
// 1) 노션 응답 그대로 (예외 처리 X)
// =============================================================
struct WaybleZoneNotionResponse: Decodable {
    struct Place: Decodable {
        let name: String?
        let address: String?
        let lat: Double?
        let lng: Double?
    }
    struct Coord: Decodable {
        let lat: Double
        let lng: Double
    }
    struct Marker: Decodable {
        let type: String
        let lat: Double
        let lng: Double
    }

    let start: Place?
    let end: Place?
    let distance: Int
    let duration: Int
    let time: String?              // 안 쓸 거면 무시
    let path: [Coord]?
    let markers: [Marker]?
}

extension WaybleZoneNotionResponse {
    func toWaybleWalk() -> WaybleWalk {
        WaybleWalk(
            distanceMeters: distance,
            durationSeconds: duration,
            path: (path ?? []).map { CLLocationCoordinate2D(latitude: $0.lat, longitude: $0.lng) },
            markers: (markers ?? []).map { .init(type: $0.type, lat: $0.lat, lng: $0.lng) },
            points: [] // 노션에는 points 없음
        )
    }
}

// =============================================================
// 2) 스웨거 응답 그대로 (예외 처리 X)
// =============================================================
struct WaybleSwaggerResponse: Decodable {
    struct DataObj: Decodable {
        struct Point: Decodable {
            let lat: Double
            let lon: Double
            let type: String?
        }
        let distance: Int
        let time: Int
        let points: [Point]?
        let polyline: [[Double]]?   // [ [lon, lat], ... ]
    }
    let errorCode: Int
    let message: String
    let data: DataObj
}

extension WaybleSwaggerResponse {
    func toWaybleWalk() -> WaybleWalk {
        // polyline: [lon, lat] → CLLocationCoordinate2D(lat, lon)
        let coords: [CLLocationCoordinate2D] = (data.polyline ?? []).compactMap { pair in
            guard pair.count == 2 else { return nil }
            return CLLocationCoordinate2D(latitude: pair[1], longitude: pair[0])
        }
        return WaybleWalk(
            distanceMeters: data.distance,
            durationSeconds: data.time,
            path: coords,
            markers: [], // 스웨거에는 markers 없음
            points: (data.points ?? []).map { .init(type: $0.type, lat: $0.lat, lng: $0.lon) }
        )
    }
}
