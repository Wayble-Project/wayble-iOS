//
//  DirectionRouter.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/29/25.
//

import Foundation
import Moya

// FIXME: - Router 양식
/// signupRouter 양식 가져옴 -> 수정하기
enum DirectionRouter {
    case get(email: String)
    case post(signupData: SignupData)
    case patch(patchData: SignupPatchRequest)
    case put(signupData: SignupData)
    case delete(email: String)
}

extension DirectionRouter: APITargetType {
    
    
    var requiresAuth: Bool {
        return true
    }
     
    
    var path: String {
        return "/auth/signup"
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
