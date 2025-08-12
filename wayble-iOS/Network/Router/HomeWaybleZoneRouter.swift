//
//  HomeWaybleZoneRouter.swift
//  wayble-iOS
//
//  Created by 이서현 on 8/12/25.
//

import Foundation
import Moya

enum HomeWaybleZoneRouter {
    case get(latitude: Double, longitude: Double, size: Int)
}

extension HomeWaybleZoneRouter: APITargetType {
    
    
    var requiresAuth: Bool {
        return true
    }
     
    
    var path: String {
        return "/api/v1/wayble-zones/recommend"
        
    }

    var method: Moya.Method {
        switch self {
        case .get:
            return .get
        }
    }

    var task: Task {
        switch self { ////api/v1/wayble-zones/recommend?latitude=37.4951233&longitude=127.045&userId=1&size=5
        case .get(let latitude, let longitude, let size):
            return .requestParameters(
                parameters: [
                    "latitude": latitude,
                    "longitude": longitude,
                    "size": size
                ],
                encoding: URLEncoding.default
            )
        }
    }
}
