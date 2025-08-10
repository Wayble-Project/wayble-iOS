//
//  SignupRouter.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/20/25.
//

import Foundation

import Moya

enum SignupRouter {
    case get(email: String)
    case post(signupData: SignupData)
    case patch(patchData: SignupPatchRequest)
    case put(signupData: SignupData)
    case delete(email: String)
}

extension SignupRouter: APITargetType {
    
    ///인증토큰 헤더 여부
    var requiresAuth: Bool {
        switch self {
        case .post:
            return false
        default:
            return true
        }
    }
    
    var path: String {
        return "/api/v1/users/signup"
    }

    var method: Moya.Method {
        switch self {
        case .get: return .get
        case .post: return .post
        case .patch: return .patch
        case .put: return .put
        case .delete: return .delete
        }
    }

    var task: Task {
        switch self {
        case .get(let email), .delete(let email):
            return .requestParameters(parameters: ["email": email], encoding: URLEncoding.queryString)
        case .post(let signupData), .put(let signupData):
            return .requestJSONEncodable(signupData)
        case .patch(let patchData):
            return .requestJSONEncodable(patchData)
        }
    }


}
