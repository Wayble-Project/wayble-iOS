//
//  NicknameRouter.swift
//  wayble-iOS
//
//  Created by 이서현 on 8/6/25.
//


import Foundation
import Moya

enum NicknameRouter {
    case get(nickname: String)
}

extension NicknameRouter: APITargetType {
    
    
    var requiresAuth: Bool {
        return true
    }
     
    
    var path: String {
        return "/api/v1/users/check-nickname"
        
    }

    var method: Moya.Method {
        switch self {
        case .get:
            return .get
        }
    }

    var task: Task {
        switch self {
        case .get(let nickname):
            return .requestParameters( ///  /check-nickname?nickname=레온
                parameters: ["nickname": nickname],
                encoding: URLEncoding.default
            )
            
        }
    }
}
