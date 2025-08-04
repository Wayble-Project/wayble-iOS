//
//  AuthViewModel.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/30/25.
//

import Foundation

@MainActor /// 메인 스레드에서 실행된다고 보장 -> DispatchQueue.main.async도 필요 없고, 클로저에서도 self를 안전하게 쓸 수 있음
class AuthViewModel: ObservableObject {
    enum AuthState {
        case unknown     // 초기 상태
        case loggedIn
        case loggedOut
        case needsOnboarding
    }

    @Published var state: AuthState = .unknown

    init() {
        checkLoginStatus()
    }

    func checkLoginStatus() {
        if let _ = KeychainManager.standard.loadSession(for: "tokenInfoKey") {
            Task {
                do {
                    if let onboardingData = try await OnboardingService().getOnboarding().data {
                        if onboardingData.nickname.isEmpty {
                            print("🚧 온보딩 필요")
                            self.state = .needsOnboarding
                        } else {
                            print("✅ 온보딩 완료")
                            self.state = .loggedIn
                        }
                    } else {
                        print("⚠️ 온보딩 데이터가 nil입니다.")
                        self.state = .loggedOut
                    }
                } catch {
                    print("⚠️ 온보딩 데이터 조회 실패: \(error)")
                    self.state = .loggedOut
                }
            }
        } else {
            print("❌ 토큰 없음, 로그인 필요")
            state = .loggedOut
        }
    }
    
    
    func hasCompletedOnboarding() async -> Bool {
        do {
            if let data = try await OnboardingService().getOnboarding().data {
                return !data.nickname.isEmpty
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}
