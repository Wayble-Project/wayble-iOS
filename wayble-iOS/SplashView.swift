//
//  SplashView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/14/25.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var selectedIndex: Int
    @Bindable var onboardingViewModel: OnboardingViewModel
    @State private var didFinishDelay = false        // ← 추가
    @State private var didFinishAuth = false         // ← 추가

    var body: some View {
        VStack {
            Image(.waybleLogo4)
                .resizable()
                .frame(width: 145, height: 95)
                .padding(.bottom, 9.19)
            Text("Wayble")
                .font(.mainTextBold30)
            ProgressView().padding(.top, 20)
        }
        .background(.white)
        .onAppear {
            // 1) 인증 체크 시작
            Task {
                await authViewModel.checkLoginStatus()
                await MainActor.run {
                    didFinishAuth = true
                    tryRouteIfReady()
                }
            }
            // 2) 최소 2초 대기
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                didFinishDelay = true
                tryRouteIfReady()
            }
        }
    }

    private func tryRouteIfReady() {
        if didFinishAuth && didFinishDelay { route() }
    }

    private func route() {
        switch authViewModel.state {
        case .loggedIn:
            selectedIndex = 0       // 홈 (프로젝트 매핑에 맞게)
        case .needsOnboarding:
            selectedIndex = 13      // 온보딩
        case .loggedOut, .unknown:
            selectedIndex = 7       // 로그인
        }
    }
}

///1.    앱 시작 → SplashView 표시
///2.    동시에 두 작업 시작
///•    작업 A: checkLoginStatus() 실행해서 토큰/온보딩 상태 확인
///•    작업 B: 2초 타이머 시작

///•    토큰 없으면 → .loggedOut
///•    토큰 있으면 → 서버에서 온보딩 정보 GET
      ///•    일부 누락 → .needsOnboarding
      ///•    전부 있음 → .loggedIn

