//
//  WaybleWalkResponse.swift
//  wayble-iOS
//
//  Created by 신민정 on 8/17/25.
//

import Foundation
import CoreLocation




struct WaybleWalkResponse: Decodable {
    let errorCode: Int?      // 성공일 땐 없음
    let message: String?     // 성공일 땐 없음
    let data: WalkData?      // 에러일 땐 없음
}

// 실제 데이터
struct WalkData: Decodable {
    let distance: Int        // 총 거리 (m)
    let time: Int            // 총 시간 (sec)
    let points: [WalkPoint]  // 주요 지점들 (램프, 엘리베이터 등)
    let polyline: [[Double]] // 경로 좌표 리스트 (lat, lon)
}

// 포인트(예: RAMP, ELEVATOR 등)
struct WalkPoint: Decodable {
    let lat: Double
    let lon: Double
    let type: String
}
