//
//  HomeWaybleZoneService.swift
//  wayble-iOS
//
//  Created by 이서현 on 8/12/25.
//

import Foundation
import Moya

final class HomeWaybleZoneService {
    
    //private let provider = MoyaProvider<NicknameRouter>()
    private let provider = APIManager.shared.createProvider(for: HomeWaybleZoneRouter.self)
    
    
    func getHomeWaybleZone(latitude: Double, longitude: Double, size: Int) async throws -> HomeWaybleZoneResponse {
        let response = try await provider.requestAsync(
            .get(latitude: latitude, longitude: longitude, size: size)
        )
        print("Status Code: \(response.statusCode)")
        print("🔎 추천존 GET 응답 바디: \(String(data: response.data, encoding: .utf8) ?? "없음")")

        // 상태 코드 확인 (성공 범위가 아니면 에러 응답을 우선 시도 디코딩)
        guard (200..<300).contains(response.statusCode) else {
            if let err = try? JSONDecoder().decode(ErrorResponse.self, from: response.data) {
                throw NSError(domain: "HomeWaybleZoneService", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: err.message])
            }
            throw URLError(.badServerResponse)
        }

        guard !response.data.isEmpty else {
            print("⚠️ 추천존 GET 응답 바디가 비어 있음 → 디코딩 생략")
            throw URLError(.badServerResponse)
        }

        let decodedResponse = try JSONDecoder().decode(HomeWaybleZoneResponse.self, from: response.data)
        return decodedResponse
    }

    
}
