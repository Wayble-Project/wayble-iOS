//
//  PlaceService.swift
//  wayble-iOS
//
//  Created by 신민정 on 8/18/25.
//

import Foundation
import Moya

final class PlaceService {

    
    private let provider = APIManager.shared.createProvider(for: PlaceRouter.self)

  
    @discardableResult
    func createSearches(_ body: PlaceRequest) async throws -> PlaceResponse {
        let response = try await provider.requestAsync(.create(body: body))

        print("Status Code: \(response.statusCode)")
        print("🔎 응답 바디:", String(data: response.data, encoding: .utf8) ?? "없음")

        guard !response.data.isEmpty else {
            print("⚠️ 응답 바디가 비어 있음 → 디코딩 생략")
            throw URLError(.badServerResponse)
        }

        do {
            let decoded = try JSONDecoder().decode(PlaceResponse.self, from: response.data)
            return decoded
        } catch {
            print("PlaceResponse 디코딩 실패: \(error.localizedDescription)")
            throw error
        }
    }

    @discardableResult
    func createSingleSearch(name: String, address: PlaceRequest.Address) async throws -> PlaceResponse {
        let req = PlaceRequest(requests: [.init(name: name, address: address)])
        return try await createSearches(req)
    }
    // MARK: - Histories (GET)
    private struct HistoryItemDTO: Decodable {
        let name: String?
        let query: String?
        let title: String?
        let createdAt: String?
        let created_at: String?
    }

    private struct HistoryResponseDTO: Decodable {
        let items: [HistoryItemDTO]

        private enum CodingKeys: String, CodingKey { case errorCode, message, data, items, histories }

        init(from decoder: Decoder) throws {
            let c = try decoder.container(keyedBy: CodingKeys.self)
            if let arr = try? c.decode([HistoryItemDTO].self, forKey: .data) { items = arr; return }
            if let arr = try? c.decode([HistoryItemDTO].self, forKey: .items) { items = arr; return }
            if let arr = try? c.decode([HistoryItemDTO].self, forKey: .histories) { items = arr; return }
            if let names = try? c.decode([String].self, forKey: .data) {
                items = names.map { HistoryItemDTO(name: $0, query: nil, title: nil, createdAt: nil, created_at: nil) }
                return
            }
            items = []
        }
    }

    /// 서버의 검색 기록을 불러와 UI용 모델로 변환
    func fetchHistories() async throws -> [SearchModel] {
        let response = try await provider.requestAsync(.histories)
        guard !response.data.isEmpty else { return [] }

        let decoded = try JSONDecoder().decode(HistoryResponseDTO.self, from: response.data)
        let iso = ISO8601DateFormatter()
        let out = DateFormatter(); out.locale = Locale(identifier: "ko_KR"); out.dateFormat = "yyyy.MM.dd HH:mm"

        let models: [SearchModel] = decoded.items.map { dto in
            let title = dto.name ?? dto.query ?? dto.title ?? ""
            let dateSource = dto.createdAt ?? dto.created_at
            let dateStr: String = {
                if let s = dateSource, let d = iso.date(from: s) { return out.string(from: d) }
                return ""
            }()
            return SearchModel(icon: "marker", title: title, date: dateStr)
        }
        return models
    }
}
