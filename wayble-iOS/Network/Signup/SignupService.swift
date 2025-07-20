//
//  SignupAPIService.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/21/25.
//

import Foundation
import Moya

final class SignupService {
    private let provider = MoyaProvider<SignupRouter>()

    func getSignup(email: String) async throws -> SignupData {
        do {
            let response = try await provider.requestAsync(.get(email: email))
            let decodedData = try JSONDecoder().decode(SignupData.self, from: response.data)
            print("GET 성공: \(decodedData)")
            return decodedData
        } catch {
            print("요청 혹은 디코딩 실패: \(error.localizedDescription)")
            throw error
        }
    }

    func createSignup(_ signupData: SignupData) async throws -> SignupData {
        do {
            let response = try await provider.requestAsync(.post(signupData: signupData))
            let decodedData = try JSONDecoder().decode(SignupData.self, from: response.data)
            print("POST 성공: \(decodedData)")
            return decodedData
        } catch {
            print("POST 요청 혹은 디코딩 실패: \(error.localizedDescription)")
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
