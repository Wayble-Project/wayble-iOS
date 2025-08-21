//
//  MainMapService.swift
//  wayble-iOS
//
//  Created by 이서현 on 8/12/25.
//

import Foundation
import Moya

final class MainMapService {
    
    private let provider = APIManager.shared.createProvider(for: MainMapRouter.self)
    
    
    func getHomeWaybleZone(latitude: Double, longitude: Double, facilityType: String) async throws -> MainMapResponse {
        let response = try await provider.requestAsync(
            .get(latitude: latitude, longitude: longitude, facilityType: facilityType)
        )
        print("Status Code: \(response.statusCode)")
        //print("🔎 main시설 GET 응답 바디: \(String(data: response.data, encoding: .utf8) ?? "없음")")

        // 상태 코드 확인 (성공 범위가 아니면 에러 응답을 우선 시도 디코딩)
        guard (200..<300).contains(response.statusCode) else {
            if let err = try? JSONDecoder().decode(ErrorResponse.self, from: response.data) {
                throw NSError(domain: "HomeWaybleZoneService", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: err.message])
            }
            throw URLError(.badServerResponse)
        }

        guard !response.data.isEmpty else {
            print("⚠️ main시설 GET 응답 바디가 비어 있음 → 디코딩 생략")
            throw URLError(.badServerResponse)
        }

        let decodedResponse = try JSONDecoder().decode(MainMapResponse.self, from: response.data)
        return decodedResponse
    }

    
}
