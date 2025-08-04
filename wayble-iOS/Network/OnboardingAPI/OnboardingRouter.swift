//
//  OnboardingRouter.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/20/25.
//

import Foundation
import Moya

enum OnboardingRouter {
    case get
    case post(onboardingData: OnboardingData)
    case patch(patchData: OnboardingRequest)
    case put(onboardingdata: OnboardingData)
    case delete(email: String)
}

extension OnboardingRouter: APITargetType {
    
    
    var requiresAuth: Bool {
        return true
    }
    
    var path: String {
        return "/api/v1/users/info"
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
        case .get, .delete:
            return .requestPlain
        case .post(let onboardingData), .put(let onboardingData):
            return .requestJSONEncodable(onboardingData)
        case .patch(let patchData):
            return .requestJSONEncodable(patchData)
        }
    }
    
    ///샘플데이터
    /*
    var sampleData: Data {
        switch self {
        case .post:
            return Data(
                """
                {
                  "data": "내 정보 등록 완료"
                }
                """.utf8
            )
        default:
            return Data()
        }
    }
    */
}
