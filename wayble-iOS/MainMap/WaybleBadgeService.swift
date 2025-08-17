//
//  WaybleBadgeService.swift
//  wayble-iOS
//
//  Created by 이서현 on 8/15/25.
//

import Foundation
import Moya

///  ErrorResponse { errorCode, message } 사용!!


enum WaybleBadgeServiceError: LocalizedError {
    case invalidInput(String)
    case api(errorCode: Int, message: String)
    case http(status: Int)
    case emptyResponse

    var errorDescription: String? {
        switch self {
        case .invalidInput(let message):
            return message
        case .api(_, let message):
            return message
        case .http(let status): 
            return "HTTP 오류 (status: \(status))"
        case .emptyResponse: 
            return "응답 바디가 비어 있습니다."
        }
    }
}

final class WaybleBadgeService {
    
    private let provider = APIManager.shared.createProvider(for: WaybleBadgeRouter.self)
    
    
    func getWaybleBadge(latitude: Double, longitude: Double, zoneName: String) async throws -> WaybleBadgeResponse {
        /// 명세:  zoneName은 null 불가, 최소 2글자
        let trimmed = zoneName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 2 else {
            throw WaybleBadgeServiceError.invalidInput("zoneName은 최소 2글자 이상이어야 합니다.")
        }
        let response = try await provider.requestAsync(
            .get(latitude: latitude, longitude: longitude, zoneName: trimmed)
        )
        print("Status Code: \(response.statusCode)")
        print("🔎 main시설 GET 응답 바디: \(String(data: response.data, encoding: .utf8) ?? "없음")")

        // 상태 코드 확인 (성공 범위가 아니면 에러 응답을 우선 시도 디코딩)
        guard (200..<300).contains(response.statusCode) else {
            if let apiError = try? JSONDecoder().decode(ErrorResponse.self, from: response.data) {
                throw WaybleBadgeServiceError.api(errorCode: apiError.errorCode, message: apiError.message)
            }
            throw WaybleBadgeServiceError.http(status: response.statusCode)
        }

        guard !response.data.isEmpty else {
            print("⚠️ 웨이블존 검증 응답 바디가 비어 있음 → 웨이블존 없음으로 간주")
            throw WaybleBadgeServiceError.emptyResponse
        }

        let decodedResponse = try JSONDecoder().decode(WaybleBadgeResponse.self, from: response.data)
        return decodedResponse
    }

    
}
