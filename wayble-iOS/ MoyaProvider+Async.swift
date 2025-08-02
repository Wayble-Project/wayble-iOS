//
//   MoyaProvider+Async.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/29/25.
//

import Foundation
import Moya

extension MoyaProvider {
    /// `async/await`으로 Moya 요청을 처리할 수 있도록 변환한 함수
    func asyncRequest(_ target: Target) async throws -> Response {
        try await withCheckedThrowingContinuation { continuation in
            self.request(target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
