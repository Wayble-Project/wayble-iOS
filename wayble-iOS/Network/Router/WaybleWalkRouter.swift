//
//  WaybleWalkRouter.swift
//  wayble-iOS
//
//  Created by 신민정 on 8/17/25.
//

import Foundation
import Moya

enum WaybleWalkRouter {
    case get(startX: Double, startY: Double, endX: Double, endY: Double, startName: String, endName: String)
}

extension WaybleWalkRouter: APITargetType {
    
    var requiresAuth: Bool {
        return true
    }
    
    var path: String {
        return "/api/v1/directions/wayble"
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
           
            let params: [String: Any] = [
                "startLat": startY,
                "startLng": startX,  // 서버가 Lon을 쓰면 아래 두 줄도 함께 유지
                "startLon": startX,
                "endLat":   endY,
                "endLng":   endX,
                "endLon":   endX,
                "startName": startName,
                "endName":   endName
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.queryString)
        }
    }
}
