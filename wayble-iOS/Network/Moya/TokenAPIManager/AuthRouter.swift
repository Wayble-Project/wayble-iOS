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
            return "/member/reissue"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .sendRefreshToken:
            return .post
            //FIXME: - get인지 post인지 확인해봐야함
        }
    }
    
    var task: Task {
        switch self {
        case .sendRefreshToken:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .sendRefreshToken(let refresh):
            var headers = ["Content-Type": "application/json"]
            headers["Refresh-Token"] = "\(refresh)"
            
            return headers
        }
    }
}
