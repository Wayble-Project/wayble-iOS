//
//  AuthRouter.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/30/25.
//




import Foundation
import Moya

enum AuthRouter {
    case sendRefreshToken(refreshToken: String) // 리프레시 토큰 갱신
}

extension AuthRouter: APITargetType {
    
    var requiresAuth: Bool {
        switch self {
        case .sendRefreshToken:
            return false
        }
    }
    
    var path: String {
        switch self {
        case .sendRefreshToken:
            return "/api/v1/auth/reissue"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sendRefreshToken:
            return .post
        }
    }
    
    var task: Task {
        switch self {
        case let .sendRefreshToken(refreshToken):
            return .requestParameters(
                parameters: ["refreshToken": refreshToken],
                encoding: URLEncoding.queryString
            )
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .sendRefreshToken:
            return nil
        }
    }
}
