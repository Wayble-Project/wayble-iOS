//
//  TokenProviding.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/30/25.
//


import Foundation
import Moya

private struct ReissueTokens: Decodable { let accessToken: String; let refreshToken: String }
private struct TokenReissueResponse: Decodable { let data: ReissueTokens?; let errorCode: Int?; let message: String? }

protocol TokenProviding {
    var accessToken: String? { get set }
    func refreshToken(completion: @escaping (String?, Error?) -> Void)
}

extension TokenProviding {
    /// 기본 구현: Keychain에서 refreshToken을 읽어 새 accessToken/refreshToken을 발급받고 Keychain 갱신 후 completion 호출
    /// - Note: 프로젝트에 존재하는 KeychainManager/TokenInfo/AuthRouter 네이밍이 다를 수 있으니 필요하면 파일명/타입명을 맞춰 주세요.
    func refreshToken(completion: @escaping (String?, Error?) -> Void) {
        // 1) Keychain에서 현재 세션 조회 (프로젝트에서 사용하는 key를 맞춰주세요)
        let key = "tokenInfoKey"
        guard let session = KeychainManager.standard.loadSession(for: key),
              !session.refreshToken.isEmpty else {
            let err = NSError(domain: "TokenProvider", code: -100, userInfo: [NSLocalizedDescriptionKey: "No refresh token in Keychain"])
            completion(nil, err)
            return
        }

        let refresh = session.refreshToken

        // 2) 만료된 access 토큰이 또 붙지 않도록 별도의 MoyaProvider를 사용 (필요시 APIManager에서 refresh 전용 세션을 노출해도 됨)
        let provider = MoyaProvider<AuthRouter>()

        // 3) 서버에 재발급 요청 (라우터 케이스/파라미터는 프로젝트에 맞춰 조정)
        provider.request(.sendRefreshToken(refreshToken: refresh)) { result in
            switch result {
            case .failure(let error):
                completion(nil, error)

            case .success(let response):
                do {

                    // 빈 바디 방지
                    guard !response.data.isEmpty else {
                        throw NSError(domain: "TokenProvider", code: -101, userInfo: [NSLocalizedDescriptionKey: "Empty response body"])
                    }

                    let decoded = try JSONDecoder().decode(TokenReissueResponse.self, from: response.data)
                    guard let tokens = decoded.data else {
                        throw NSError(domain: "TokenProvider", code: -102, userInfo: [NSLocalizedDescriptionKey: decoded.message ?? "Token reissue failed"])
                    }

                    // 5) Keychain 세션 업데이트 (access/refresh 모두 원자적으로 저장)
                    var newSession = session
                    newSession.accessToken = tokens.accessToken
                    newSession.refreshToken = tokens.refreshToken
                    _ = KeychainManager.standard.saveSession(newSession, for: key)

                    // 6) 호출자에게 새 accessToken 반환
                    completion(tokens.accessToken, nil)
                } catch {
                    completion(nil, error)
                }
            }
        }
    }
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
