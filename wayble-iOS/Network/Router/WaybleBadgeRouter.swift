//
//  WaybleBadgeRouter.swift
//  wayble-iOS
//
//  Created by 이서현 on 8/15/25.
//

import Foundation
import Moya

enum WaybleBadgeRouter {
    case get(latitude: Double, longitude: Double, zoneName: String)
}

extension WaybleBadgeRouter: APITargetType {
    
    
    var requiresAuth: Bool {
        return true
    }
     
    
    var path: String {
        return "api/v1/wayble-zones/search/validate"
        
    }

    var method: Moya.Method {
        switch self {
        case .get:
            return .get
        }
    }

    var task: Task {
        switch self { /// /api/v1/wayble-zones/search/validate?latitude=37.4951233&longitude=127.045&zoneName=베스킨
        case .get(let latitude, let longitude, let zoneName):
            return .requestParameters(
                parameters: [
                    "latitude": latitude,
                    "longitude": longitude,
                    "zoneName": zoneName
                ],
                encoding: URLEncoding.default
            )
        }
    }
}

