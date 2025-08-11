//
//  LoginService.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/30/25.
//

import Foundation
import Moya

final class LoginService {
    //private let provider = MoyaProvider<LoginRouter>()
    private let provider = APIManager.shared.createProvider(for: LoginRouter.self)
    ///private let provider = APIManager.shared.createProvider(for: LoginRouter.self) ///accessToken 재발급 코드와 연결? -> 앞으로 토큰 필요한 건 다 이렇게  0807
    ///로그인 후부터 사용 (로그인 파트는 필요 없는 듯)

    func login(_ loginData: LoginData) async throws -> TokenInfo {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            if let requestBody = try? encoder.encode(loginData),
               let requestBodyString = String(data: requestBody, encoding: .utf8) {
                print("요청 바디:\n\(requestBodyString)")
            }
            
            let response = try await provider.requestAsync(.post(loginData: loginData))
            
            ///서버 응답의 statusCode와 실제 body 내용이 콘솔에 출력되고, 200 OK일 때만 디코딩이 시도
            print("Status Code: \(response.statusCode)")
            print(String(data: response.data, encoding: .utf8) ?? "응답 데이터 없음")

            guard response.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }

            let decodedData = try JSONDecoder().decode(TokenResponse.self, from: response.data)
            print("POST 성공: \(decodedData)")
            return decodedData.data
        } catch {
            print("POST 요청 혹은 디코딩 실패: \(error.localizedDescription)")
            throw error
        }
    }
}
