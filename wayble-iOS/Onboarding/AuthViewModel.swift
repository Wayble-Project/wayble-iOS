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

    init() {}

    /*
     init() {
         checkLoginStatus() ///async 붙이기 전
     }
     */
    

    func checkLoginStatus() async { /// async 을 써야 하나?
        if let _ = KeychainManager.standard.loadSession(for: "tokenInfoKey") {
            ///키체인에 저장된 토큰이 있는지 확인
            ///"tokenInfoKey" => 저장할 때 사용한 key 이름
            do {
                let onboardingResponse = try await OnboardingService().getOnboarding()
                if let data = onboardingResponse.data {
                    let isIncomplete = data.nickname == nil ||
                                       data.birthDate == nil ||
                                       data.gender == nil ||
                                       data.userType == nil
                    if isIncomplete {
                        print("🟡 온보딩 정보 일부 누락 → 온보딩 화면으로 이동")
                        self.state = .needsOnboarding
                    } else {
                        print("✅ 온보딩 완료")
                        self.state = .loggedIn
                    }
                } else {
                    print("등록된 유저 정보 없음! -> 온보딩 화면으로 이동")
                    self.state = .needsOnboarding
                }
            } catch { //FIXME: - 이 부분은 어떻게 해결할까 에러 처리를 ... 로그아웃으로 하는 게 맞나
                print("⚠️ 온보딩 데이터 조회 실패로 로그인 화면으로 이동 , 에러: \(error)")
                self.state = .loggedOut
            }
        } else { ///토큰이 없을 시 (if let 바인딩)
            print("❌ 토큰 없음, 로그인 필요")
            self.state = .loggedOut
        }
    }
    
    
    func checkAutoLogin() async { /// async 을 써야 하나?
        if let _ = KeychainManager.standard.loadSession(for: "tokenInfoKey") {
        }
    }
}
