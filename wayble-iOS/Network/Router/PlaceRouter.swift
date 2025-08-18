//
//  PlaceRouter.swift
//  wayble-iOS
//
//  Created by 신민정 on 8/18/25.
//
//

import Foundation
import Moya

enum PlaceRouter {
    case create(body: PlaceRequest)
    case histories   // ✅ 추가
}

extension PlaceRouter: APITargetType {

    var requiresAuth: Bool { true }

    var path: String {
        switch self {
        case .create:
            return "/api/v1/directions/place"         // POST 저장
        case .histories:
            return "/api/v1/directions/searches" //사실상없음 
        }
    }

    var method: Moya.Method {
        switch self {
        case .create:
            return .post
        case .histories:   // ✅ GET 요청
            return .get
        }
    }

    var task: Task {
        switch self {
        case let .create(body):
            return .requestJSONEncodable(body)
        case .histories:   // ✅ body 없음
            return .requestPlain
        }
    }
}
