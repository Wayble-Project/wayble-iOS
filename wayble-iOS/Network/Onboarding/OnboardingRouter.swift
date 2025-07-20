//
//  OnboardingRouter.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/20/25.
//

import Foundation
import Moya

enum OnboardingRouter {
    case get(email: String)
    case post(onboardingData: OnboardingData)
    case patch(patchData: OnboardingRequest)
    case put(onboardingdata: OnboardingData)
    case delete(email: String)
}

extension OnboardingRouter: APITargetType {
    var path: String {
        return "/users/onboarding"
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
        case .post(let onboardingData), .put(let onboardingData):
            return .requestJSONEncodable(onboardingData)
        case .patch(let patchData):
            return .requestJSONEncodable(patchData)
        }
    }
}
