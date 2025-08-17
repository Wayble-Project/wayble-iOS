//
//  AccessTokenRefresher.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/30/25.
//

import Foundation
import Alamofire

class AccessTokenRefresher: @unchecked Sendable, RequestInterceptor {
    private var tokenProviding: TokenProviding
    private var isRefreshing: Bool = false
    private var requestToRetry: [(RetryResult) -> Void] = [] // 실패했던 것들 담아놓고 다시 리트라이하고 배열 비우고.. 이런 식인 듯

    // MARK: - Singleton configuration
    private static var _shared: AccessTokenRefresher?
    static var shared: AccessTokenRefresher {
        guard let s = _shared else {
            fatalError("AccessTokenRefresher is not configured. Call AccessTokenRefresher.configure(provider:) at app launch.")
        }
        return s
    }

    static func configure(provider: TokenProviding) {
        _shared = AccessTokenRefresher(tokenProviding: provider)
    }
    
    init(tokenProviding: TokenProviding) {
        self.tokenProviding = tokenProviding
    }

    // MARK: - Public async refresh API (used by AuthViewModel)
    func refresh(with refreshToken: String) async throws -> TokenInfo {
        try await withCheckedThrowingContinuation { continuation in
            self.tokenProviding.refreshToken { newAccessToken, error in
                if let newAccessToken {
                    let tokenInfo = TokenInfo(accessToken: newAccessToken, refreshToken: refreshToken)
                    continuation.resume(returning: tokenInfo)
                } else {
                    continuation.resume(throwing: error ?? URLError(.badServerResponse))
                }
            }
        }
    }

    //MARK: -
    ///     •    모든 요청을 보내기 전에 adapt(_:for:completion:)이 호출됨.
    /// •    여기서 tokenProviding.accessToken이 있으면 Authorization 헤더를 붙여줌.
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest
        if let accessToken = tokenProviding.accessToken {
            urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(urlRequest))
    }
    
    //MARK: -
    /// •    서버에서 401(또는 404 — 여기선 404도 넣어놨네) 응답이 오면 호출됨.
    /// •    1회 이상 재시도하지 않도록 request.retryCount < 1 조건을 둠.
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        guard request.retryCount < 1,
              let response = request.task?.response as? HTTPURLResponse,
              [401, 404].contains(response.statusCode) else {
            return completion(.doNotRetry)
        }
        
        requestToRetry.append(completion)
        if !isRefreshing {
            isRefreshing = true
            tokenProviding.refreshToken { [weak self] newToken, error in
                guard let self = self else { return }
                self.isRefreshing = false
                let result = error == nil ? RetryResult.retry : RetryResult.doNotRetryWithError(error!)
                self.requestToRetry.forEach { $0(result) }
                self.requestToRetry.removeAll()
            }
        }
    }
}
