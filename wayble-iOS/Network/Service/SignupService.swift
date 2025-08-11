//
//  SignupAPIService.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/21/25.
//

import Foundation
import Moya

final class SignupService {
    var signupData: SignupData?
    //private let provider: MoyaProvider<SignupRouter>
    private let provider = APIManager.shared.createProvider(for: SignupRouter.self)

    init() {
        let logger = NetworkLoggerPlugin(configuration: .init(logOptions: [.verbose]))
        self.provider = MoyaProvider<SignupRouter>(plugins: [logger])
    }
    

    func createSignup(_ signupData: SignupData) async throws -> SignupResponse {
        do {
            let response = try await provider.requestAsync(.post(signupData: signupData))
            
            if response.data.isEmpty {
                print("❗️응답 바디 없음 (status: \(response.statusCode))")
                throw NSError(domain: "SignupService", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "Empty response body"])
            }

            do {
                let decodedData = try JSONDecoder().decode(SignupResponse.self, from: response.data)
                print("회원가입 POST 성공: \(decodedData)")
                return decodedData
            } catch {
                let stringData = String(data: response.data, encoding: .utf8) ?? ""
                print("회원가입 POST 응답이 문자열일 가능성 있음: \(stringData)")
                return SignupResponse(data: stringData, errorCode: nil, message: nil)
            }
        } catch {
            print("회원가입 POST 요청 혹은 디코딩 실패: \(error)")
            throw error
        }
    }

    func updateSignupPatch(_ patchData: SignupPatchRequest) async throws -> SignupPatchRequest {
        do {
            let response = try await provider.requestAsync(.patch(patchData: patchData))
            let decodedData = try JSONDecoder().decode(SignupPatchRequest.self, from: response.data)
            print("PATCH 성공: \(decodedData)")
            return decodedData
        } catch {
            print("PATCH 요청 혹은 디코딩 실패: \(error.localizedDescription)")
            throw error
        }
    }
}
