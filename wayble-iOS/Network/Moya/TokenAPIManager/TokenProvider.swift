//
//  TokenProvider.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/30/25.
//

import Foundation
import Moya

class TokenProvider: TokenProviding {
    private let userSession = "appNameUser"
    private let keyChain = KeychainManager.standard
    private let provider = MoyaProvider<AuthRouter>()
    
    var accessToken: String? {
        get {
            guard let tokenInfo = keyChain.loadSession(for: userSession) else { return nil }
            return tokenInfo.accessToken
        }
        set {
            guard var tokenInfo = keyChain.loadSession(for: userSession) else { return }
            tokenInfo.accessToken = newValue! //강제 언래핑 수정
            if keyChain.saveSession(tokenInfo, for: userSession) {
                print("유저 액세스 토큰 갱신됨: \(String(describing: newValue))")
            }
        }
    }
    
    var refreshToken: String? {
        get {
            guard let userInfo = keyChain.loadSession(for: userSession) else { return nil }
            return userInfo.refreshToken
        }
        
        set {
            guard var tokenInfo = keyChain.loadSession(for: userSession) else { return }
            tokenInfo.refreshToken = newValue! //강제 언래핑 수정
            if keyChain.saveSession(tokenInfo, for: userSession) {
                print("유저 리프레시 갱신됨")
            }
        }
    }
    func refreshToken(completion: @escaping (String?, (any Error)?) -> Void) {
        guard let tokenInfo = keyChain.loadSession(for: userSession) else {
            let error = NSError(domain: "example.com", code: -2, userInfo: [NSLocalizedDescriptionKey: "UserSession not found"])
            completion(nil, error)
            return
        }
        let refreshToken = tokenInfo.refreshToken
        
        provider.request(.sendRefreshToken(refreshToken: refreshToken)) { result in
            switch result {
            case .success(let response):
                if let jsonString = String(data: response.data, encoding: .utf8) {
                    print("응답 JSON: \(jsonString)")
                } else {
                    print("JSON 데이터를 문자열로 변환할 수 없습니다.")
                }
                
                do {
                    let tokenData = try JSONDecoder().decode(TokenResponse.self, from: response.data)
                    self.accessToken = tokenData.data.accessToken
                    self.refreshToken = tokenData.data.refreshToken // 수정
                        completion(self.accessToken, nil)
                        let error = NSError(domain: "example.com", code: -1, userInfo: [NSLocalizedDescriptionKey: "Token Refresh failed: isSuccess false"])
                        
                        //completion(nil, error)
                } catch {
                    print("디코딩 에러: \(error)")
                    completion(nil, error)
                }
                
            case .failure(let error):
                print("네트워크 에러 : \(error)")
                completion(nil, error)
            }
        }
    }
}
