//
//  WalkingRouter.swift
//  wayble-iOS
//
//  Created by 신민정 on 8/9/25.
//

import Foundation
import Moya

enum WalkingRouter {
    case get(startLat: Double, startLng: Double, endLat: Double, endLng: Double)
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
        case let .get(startLat, startLng, endLat, endLng):
            return .requestParameters(
                parameters: [
                    "startLat": startLat,
                    "startLng": startLng,
                    "endLat":   endLat,
                    "endLng":   endLng
                ],
                encoding: URLEncoding.default
            )
        }
    }
}
