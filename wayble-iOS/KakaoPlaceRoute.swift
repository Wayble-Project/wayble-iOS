//
//  KakaoPlaceRoute.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/29/25.
//

import Moya
import Foundation

enum KakaoPlaceRouter: TargetType {
    case categorySearch(lat: Double, lng: Double, radius: Int, category: String)

    var baseURL: URL {
        return URL(string: "https://dapi.kakao.com")!
    }

    var path: String {
        switch self {
        case .categorySearch:
            return "/v2/local/search/category.json"
        }
    }

    var method: Moya.Method {
        return .get
    }

    var task: Task {
        switch self {
        case let .categorySearch(lat, lng, radius, category):
            let params: [String: Any] = [
                "category_group_code": category, // 예: "FD6" (음식점), "CE7" (카페)
                "x": lng,
                "y": lat,
                "radius": radius,
                "sort": "distance"
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        @unknown default:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        guard let apiKey = Bundle.main.kakaoAPIKey.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else {
            return nil
        }
        return [
            "Authorization": "KakaoAK \(apiKey)"
        ]
    }

    var sampleData: Data {
        return Data()
    }
}

extension Bundle {
    var kakaoAPIKey: String {
        return object(forInfoDictionaryKey: "KAKAO_REST_API_KEY") as? String ?? ""
    }
}
