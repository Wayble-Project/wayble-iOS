//
//  WalkingService.swift
//  wayble-iOS
//
//  Created by 신민정 on 8/9/25.
//

import Foundation
import Moya

final class WalkingService {

    //private let provider = MoyaProvider<WalkingRouter>()
    private let provider = APIManager.shared.createProvider(for: WalkingRouter.self)

    /// 도보 최적경로 요청
    func fetchWalkingRoute(
        startLat: Double, startLng: Double,
        endLat: Double, endLng: Double
    ) async throws -> WalkingRouteResponse {

        let response = try await provider.requestAsync(
            .get(startLat: startLat, startLng: startLng, endLat: endLat, endLng: endLng)
        )

        print("Status Code: \(response.statusCode)")
        print("🔎 응답 바디:", String(data: response.data, encoding: .utf8) ?? "없음")

        guard !response.data.isEmpty else {
            print("⚠️ 응답 바디가 비어 있음 → 디코딩 생략")
            throw URLError(.badServerResponse)
        }

        do {
            let decoded = try JSONDecoder().decode(WalkingRouteResponse.self, from: response.data)
            return decoded
        } catch {
            print("도보경로 GET 디코딩 실패: \(error.localizedDescription)")
            throw error
        }
    }
}
