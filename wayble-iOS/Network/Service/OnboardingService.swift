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
    //let provider = MoyaProvider<OnboardingRouter>(stubClosure: MoyaProvider.immediatelyStub)
    /// 이건 샘플데이터 용
    func getOnboarding() async throws -> OnboardingResponse {
        let response = try await provider.requestAsync(.get)
        print("Status Code: \(response.statusCode)")
        // 응답 바디 로그 출력
        print("🔎 응답 바디: \(String(data: response.data, encoding: .utf8) ?? "없음")")
        ///서버 응답이 구조적으로 올바르면 data가 nil이어도 디코딩은 성공으로 간주
        do {
            guard !response.data.isEmpty else {
                print("⚠️ 응답 바디가 비어 있음 → 디코딩 생략")
                
                throw URLError(.badServerResponse)
            }
            let decodedResponse = try JSONDecoder().decode(OnboardingResponse.self, from: response.data)
            print("GET 성공: \(decodedResponse)")
            return decodedResponse
        } catch {
            print("온보딩 GET 디코딩 실패: \(error.localizedDescription)")
            throw error
        }
    }

    
    func createOnboarding(_ onboardingData: OnboardingData) async throws -> String {
        do {
            
            /// 요청 바디 로그 확인용
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            if let requestBody = try? encoder.encode(onboardingData),
               let requestBodyString = String(data: requestBody, encoding: .utf8) {
                print("요청 바디:\n\(requestBodyString)")
            }
            

            let response = try await provider.requestAsync(.post(onboardingData: onboardingData))
            
            /// 상태 응답 코드
            print("Status Code: \(response.statusCode)")
            print("응답 바디:\n" + (String(data: response.data, encoding: .utf8) ?? "응답 데이터 없음"))

            /*
            guard !response.data.isEmpty else {
                print("⚠️ 응답 바디가 비어 있어 디코딩 생략됨")
                throw URLError(.badServerResponse)
            }
             */
            
            let decodedResponse = try JSONDecoder().decode(OnboardingPostResponse.self, from: response.data)
            print("온보딩 POST 성공 메시지: \(decodedResponse.data)")
            return decodedResponse.data
        } catch {
            print("온보딩 POST 요청 혹은 디코딩 실패: \(error.localizedDescription)")
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
