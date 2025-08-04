//
//  WaybleZoneRouter.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/29/25.
//


import Foundation
import Moya

enum WaybleZoneAPIRouter {
    case getWaybleZone(city: String, category: String)
    case getWaybleZoneDetail(id: Int)
    case post(waybleZoneAPIData: WaybleZoneAPIData)
}

extension WaybleZoneAPIRouter: APITargetType {
    
    //FIXME: - 웨이블존은 전부 헤더 필요한지 명세서 추후에 확인해봐야 함
    var requiresAuth: Bool {
        return true
    }
    
    var path: String {
        switch self {
        case .getWaybleZone:
            return "/api/v1/wayble-zones"
        case .getWaybleZoneDetail(let id):
            return "/api/v1/wayble-zones/\(id)"
        case .post:
            return "/api/v1/wayble-zones"
        }
    }

    var method: Moya.Method {
        switch self {
        case .getWaybleZone: return .get
        case .getWaybleZoneDetail: return .get
        case .post: return .post

        }
    }

    var task: Task {
        switch self {
        case .getWaybleZone(let city, let category):
            return .requestParameters(
                parameters: ["city": city, "category": category],
                encoding: URLEncoding.queryString
            )
            
        case .getWaybleZoneDetail:
            return .requestPlain
            
        case .post(let waybleZoneAPIData):
            return .requestJSONEncodable(waybleZoneAPIData)
        }
    }
    
}
