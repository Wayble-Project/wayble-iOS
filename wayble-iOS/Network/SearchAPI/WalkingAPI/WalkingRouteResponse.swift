//
//  WalkingRouteResponse.swift
//  wayble-iOS
//
//  Created by 신민정 on 8/9/25.
//

import Foundation

struct WalkingRouteResponse: Codable {
    let errorCode: Int?
    let message: String?
    let data: WalkingRouteData?
}


struct WalkingRouteData: Codable {
    let start: WalkPoint
    let end: WalkPoint
    let distance: Int          // 미터
    let duration: Int          // 초
    let time: String           // "2025-07-11T16:27:00"
    let path: [WalkCoord]
}

struct WalkPoint: Codable {
    let name: String
    let address: String
    let lat: Double
    let lng: Double
}

struct WalkCoord: Codable {
    let lat: Double
    let lng: Double
}
