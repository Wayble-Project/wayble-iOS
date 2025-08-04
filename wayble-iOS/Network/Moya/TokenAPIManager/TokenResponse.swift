//
//  TokenResponse.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/30/25.
//

import Foundation
/// 서버에서 보내주는 response 형태 (data 안에 TokenInfo 들어간 형태)
struct TokenResponse: Codable {
    let data: TokenInfo
}



