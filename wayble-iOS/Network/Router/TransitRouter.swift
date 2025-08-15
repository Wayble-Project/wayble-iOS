//
//  TransitRouter.swift
//  wayble-iOS
//
//  Created by 신민정 on 8/14/25.
//

import Foundation

// TransitRouter.swift
// wayble-iOS

import Foundation
import Moya

enum TransitRouter {
    case search(body: TransitRequest)   // 대중교통 경로 검색 (POST JSON)
}

extension TransitRouter: APITargetType {
    // APITargetType에 baseURL/headers 공통 처리(토큰 등) 이미 있다고 가정
    var requiresAuth: Bool {
        return true
    }

    var path: String {
        return "/api/v1/directions/transportation/"
    }

    var method: Moya.Method {
        switch self {
        case .search:
            return .post
        }
    }

    var task: Task {
        switch self {
        case let .search(body):
            // JSON 바디 그대로 인코딩
            return .requestJSONEncodable(body)
        }
    }
}
