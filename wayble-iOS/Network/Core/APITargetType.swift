//
//  APITargetType.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/20/25.
//

import Foundation
import Moya

protocol APITargetType: TargetType {}

extension APITargetType {
    var baseURL: URL {
        return URL(string: "baseURL 주소")!
    }
    
    var headers: [String : String]? {
        switch task {
        case .requestJSONEncodable, .requestParameters:
            return ["Content-type": "application/json"]
        case .uploadMultipart:
            return ["Content-Type": "multipart/form-data"]
        default:
            return nil
        }
    }
}
