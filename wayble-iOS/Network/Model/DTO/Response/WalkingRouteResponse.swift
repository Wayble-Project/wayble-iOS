//
//  WalkingRouteResponse.swift
//  wayble-iOS
//
//  Created by 신민정 on 8/9/25.
//

import Foundation

struct WalkingRouteResponse: Codable {
    let data: WalkingData?
    let errorCode: Int?
    let message: String?
}

struct WalkingData: Codable {
    let totalDistance: Int
    let totalTime: Int
    let steps: [WalkingStep]
}

struct WalkingStep: Codable {
    enum StepType: String, Codable { case point, line }
    let type: StepType
    let name: String?
    let description: String?

    let coordinate: WalkingCoord?      // point
    let coordinates: [WalkingCoord]?   // line

    let turnType: Int?
    let pointType: String?

    let distance: Int?
    let time: Int?
}

struct WalkingCoord: Codable {
    let longitude: Double   // 서버는 longitude/latitude 순서
    let latitude: Double
}
