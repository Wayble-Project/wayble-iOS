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

    func checkNicknameDuplicate(nickname: String) async throws -> NicknameResponse { ///0807
        let response = try await provider.requestAsync(.get(nickname: nickname))
        print("Status Code: \(response.statusCode)")
        // 응답 바디 로그 출력
        print("🔎 응답 바디: \(String(data: response.data, encoding: .utf8) ?? "없음")")
        ///서버 응답이 구조적으로 올바르면 data가 nil이어도 디코딩은 성공으로 간주
        do {
            guard !response.data.isEmpty else {
                print("⚠️ 응답 바디가 비어 있음 → 디코딩 생략")
                
                throw URLError(.badServerResponse)
            }
            let decodedResponse = try JSONDecoder().decode(NicknameResponse.self, from: response.data)
            print("닉네임 GET 성공: \(decodedResponse)")
            return decodedResponse
        } catch {
            print("닉네임 GET 디코딩 실패: \(error.localizedDescription)")
            throw error
        }
    }

    
}
