//
//  OnboardingService.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/21/25.
//


import Foundation
import Moya

final class OnboardingService {
    private let provider = MoyaProvider<OnboardingRouter>()

    func getOnboarding(email: String) async throws -> OnboardingData {
        do {
            let response = try await provider.requestAsync(.get(email: email))
            let decodedData = try JSONDecoder().decode(OnboardingData.self, from: response.data)
            print("GET 성공: \(decodedData)")
            return decodedData
        } catch {
            print("요청 혹은 디코딩 실패: \(error.localizedDescription)")
            throw error
        }
    }

    func createOnboarding(_ onboardingData: OnboardingData) async throws -> OnboardingData {
        do {
            let response = try await provider.requestAsync(.post(onboardingData: onboardingData))
            let decodedData = try JSONDecoder().decode(OnboardingData.self, from: response.data)
            print("POST 성공: \(decodedData)")
            return decodedData
        } catch {
            print("POST 요청 혹은 디코딩 실패: \(error.localizedDescription)")
            throw error
        }
    }

    func updateOnboardingPatch(_ patchData: OnboardingRequest) async throws -> OnboardingRequest {
        do {
            let response = try await provider.requestAsync(.patch(patchData: patchData))
            let decodedData = try JSONDecoder().decode(OnboardingRequest.self, from: response.data)
            print("PATCH 성공: \(decodedData)")
            return decodedData
        } catch {
            print("PATCH 요청 혹은 디코딩 실패: \(error.localizedDescription)")
            throw error
        }
    }

    func updateOnboardingPut(_ onboardingData: OnboardingData) async throws -> OnboardingData {
        do {
            let response = try await provider.requestAsync(.put(onboardingdata: onboardingData))
            let decodedData = try JSONDecoder().decode(OnboardingData.self, from: response.data)
            print("PUT 성공: \(decodedData)")
            return decodedData
        } catch {
            print("PUT 요청 혹은 디코딩 실패: \(error.localizedDescription)")
            throw error
        }
    }

    func deleteOnboarding(email: String) async throws {
        do {
            _ = try await provider.requestAsync(.delete(email: email))
            print("DELETE 성공")
        } catch {
            print("DELETE 요청 실패: \(error.localizedDescription)")
            throw error
        }
    }
}
