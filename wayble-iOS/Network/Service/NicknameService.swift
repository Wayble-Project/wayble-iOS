//
//  NicknameService.swift
//  wayble-iOS
//
//  Created by 이서현 on 8/6/25.
//

import Foundation
import Moya

final class NicknameService {
    
    private let provider = MoyaProvider<NicknameRouter>()

    func checkNicknameDuplicate(nickname: String) async throws -> NicknameResponse {
        let response = try await provider.requestAsync(.get(nickname: nickname))
        print("Status Code: \(response.statusCode)")
        print("🔎 응답 바디: \(String(data: response.data, encoding: .utf8) ?? "없음")")

        let decodedResponse = try JSONDecoder().decode(NicknameResponse.self, from: response.data)

        // 중복이거나 파라미터 누락 등: errorCode/message만 있는 경우 → 유효한 응답으로 간주
        if let errorCode = decodedResponse.errorCode, decodedResponse.data == nil {
            print("🚫 닉네임 중복 확인 결과 - 코드 \(errorCode): \(decodedResponse.message ?? "")")
            return NicknameResponse(errorCode: errorCode, message: decodedResponse.message, data: nil)
        }

        // 정상 응답: data가 있는 경우
        if let data = decodedResponse.data {
            print("✅ 닉네임 사용 가능 여부: \(data.available)")
            return decodedResponse
        }

        // 바디가 비정상적으로 비어있는 경우
        print("⚠️ 닉네임 응답에 유효한 정보 없음")
        throw URLError(.badServerResponse)
    }

    
}
