//
//  APITargetType.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/20/25.
//

import Foundation
import Moya

protocol APITargetType: TargetType {
    var requiresAuth: Bool { get } ///헤더에 인증토큰을 필요로 하는지 확인 -> Router에서 변수 상태 설정하면 됨 (아래 예시)
    ///extension SignupRouter: APITargetType {
    
    ///인증토큰 헤더 여부
    
    /*var requiresAuth: Bool {
        switch self {
        case .post:
            return false
        default:
            return true
        }
    }
     */
}

extension APITargetType {
    var baseURL: URL { /// GPT
        guard let urlString = Bundle.main.infoDictionary?["API_BASE_URL"] as? String,
              let url = URL(string: urlString) else {
            fatalError("❌ API_BASE_URL not found or invalid in Info.plist ❌")
        }
        return url
    }
    
    
    var headers: [String : String]? {
        var header: [String: String] = [:]
        
        switch task {
        case .requestJSONEncodable, .requestParameters:
            header["Content-Type"] = "application/json"
        case .uploadMultipart:
            header["Content-Type"] = "multipart/form-data"
        default:
            break
        }

        
        if requiresAuth,
           let tokenInfo = KeychainManager.standard.loadSession(for: "tokenInfoKey") {
            header["Authorization"] = "Bearer \(tokenInfo.accessToken)"
        }
         

        return header
    }
    
    
    
}
