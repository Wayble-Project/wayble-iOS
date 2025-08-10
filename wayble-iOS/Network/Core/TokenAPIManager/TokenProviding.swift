//
//  TokenProviding.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/30/25.
//

import Foundation

protocol TokenProviding {
    var accessToken: String? { get set }
    func refreshToken(completion: @escaping (String?, Error?) -> Void)
}

/*
 func refreshToken(completion: @escaping (TokenInfo?, Error?) -> Void) {
     // Keychain에서 refreshToken 불러오기
     // POST /auth/reissue 요청 보내기
     // 응답으로 accessToken, refreshToken 다시 받기
     // Keychain 업데이트
     // completion(TokenInfo, nil) or completion(nil, error)
 }
 */
