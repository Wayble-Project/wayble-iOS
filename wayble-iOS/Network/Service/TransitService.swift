//
//  TransitService.swift
//  wayble-iOS
//
//  Created by 신민정 on 8/14/25.
//

import Foundation
import Moya

final class TransitService {

    private let provider = APIManager.shared.createProvider(for: TransitRouter.self)

    /// 공용 호출
    func fetchTransitRoutes(
        origin: TransitRequest.PlacePoint,
        destination: TransitRequest.PlacePoint,
        cursor: Int? = nil,
        size: Int = 5
    ) async throws -> TransitResponse {

        let body = TransitRequest(origin: origin, destination: destination, cursor: cursor, size: size)

        let response = try await provider.requestAsync(.search(body: body))

        print("[Transit] Status Code: \(response.statusCode)")
        if let raw = String(data: response.data, encoding: .utf8) {
            print("[Transit] 🔎 응답 바디: \(raw)")
        } else {
            print("[Transit] 🔎 응답 바디: (문자열 변환 실패)")
        }

        guard !response.data.isEmpty else {
            throw URLError(.badServerResponse)
        }

        do {
            // ✅ envelope → payload(data)로 꺼내서 반환
            let decoded = try JSONDecoder().decode(TransitEnvelope.self, from: response.data)
            return decoded.data
        } catch {
            print("[Transit] 디코딩 실패: \(error.localizedDescription)")
            throw error
        }
    }

    func fetchFirst(
        origin: TransitRequest.PlacePoint,
        destination: TransitRequest.PlacePoint,
        size: Int = 5
    ) async throws -> TransitResponse {
        try await fetchTransitRoutes(origin: origin, destination: destination, cursor: nil, size: size)
    }

    func fetchNext(
        origin: TransitRequest.PlacePoint,
        destination: TransitRequest.PlacePoint,
        cursor: Int? = nil,
        size: Int = 5
    ) async throws -> TransitResponse {
        try await fetchTransitRoutes(origin: origin, destination: destination, cursor: cursor, size: size)
    }
}
