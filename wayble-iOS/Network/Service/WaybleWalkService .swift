//
//  WaybleWalkService .swift
//  wayble-iOS
//
//  Created by 신민정 on 8/17/25.
//


import Foundation
import Moya

final class WaybleWalkService {
    
    //private let provider = MoyaProvider<WaybleWalkRouter>()
    private let provider = APIManager.shared.createProvider(for: WaybleWalkRouter.self)
    
    /// 웨이블존 도보 최적경로 요청
    func fetchWaybleWalkRoute(
        startX: Double, startY: Double,
        endX: Double, endY: Double,
        startName: String, endName: String
    ) async throws -> WaybleWalkResponse {
        
        let response = try await provider.requestAsync(
            .get(
                startX: startX, startY: startY,
                endX: endX, endY: endY,
                startName: startName, endName: endName
            )
        )
        
        print("Status Code: \(response.statusCode)")
        print("🔎 응답 바디:", String(data: response.data, encoding: .utf8) ?? "없음")
        
        guard !response.data.isEmpty else {
            print("⚠️ 응답 바디가 비어 있음 → 디코딩 생략")
            throw URLError(.badServerResponse)
        }
        
        do {
            let decoded = try JSONDecoder().decode(WaybleWalkResponse.self, from: response.data)
            return decoded
        } catch {
            print("🚨 웨이블존 도보 GET 디코딩 실패: \(error.localizedDescription)")
            throw error
        }
    }
}
