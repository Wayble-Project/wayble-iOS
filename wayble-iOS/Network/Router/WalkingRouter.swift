//
//  WalkingRouter.swift
//  wayble-iOS
//
//  Created by 신민정 on 8/9/25.
//

import Foundation
import Moya

enum WalkingRouter {
    case get(startX: Double, startY: Double, endX: Double, endY: Double, startName: String, endName: String)
}

extension WalkingRouter: APITargetType {

    
    var requiresAuth: Bool {
        return true
    }
     

    var path: String {
        return "/api/v1/directions/walking"
    }

    var method: Moya.Method {
        switch self {
        case .get:
            return .get
        }
    }

    var task: Task {
        switch self {
        case let .get(startX, startY, endX, endY, startName, endName):
            return .requestParameters(
                parameters: [
                    "startX": startX,   // 경도(lng)
                    "startY": startY,   // 위도(lat)
                    "endX":   endX,     // 경도(lng)
                    "endY":   endY,     // 위도(lat)
                    "startName": startName,
                    "endName":   endName
                ],
                encoding: URLEncoding.default
            )
        }
    }
}
