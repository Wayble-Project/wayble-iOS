//
//  LoginRouter.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/30/25.
//


import Foundation

import Moya

enum LoginRouter {
    case post(loginData: LoginData)
}

extension LoginRouter: APITargetType {
    var path: String {
        return "/api/v1/auth/login/basic"
    }

    
    var requiresAuth: Bool {
        return false
    }
     

    var method: Moya.Method {
        switch self {
        case .post: return .post
        }
    }

    var task: Task {
        switch self {
        case .post(let loginData):
            return .requestJSONEncodable(loginData)
        }
    }
}
