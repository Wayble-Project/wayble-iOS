//
//  LoginView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/14/25.
//

import SwiftUI

import Foundation


struct LoginView: View {
    
    enum Field {
        case email
        case password
    }
    @Binding var selectedIndex: Int
    @Environment(NavigationRouter.self) private var router
    @FocusState private var focusedField: Field?
    //@State var email: String
    @Bindable var viewModel = LoginViewModel()
    @Bindable var onboardingViewModel: OnboardingViewModel
    @Bindable var homeViewModel: HomeViewModel
    @State private var loginFailed = false
    @State private var isLoading = false
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                headerIcon
                    .padding(.bottom, 35)
                
                EmailField(
                    email: $viewModel.userInfo.email,
                    storedEmail: "abc@naver.com",
                    isCheckingMismatch: false
                )
                .submitLabel(.next)
                .focused($focusedField, equals: .email)
                .onSubmit {
                    focusedField = .password
                }
                .padding(.bottom, 8)
                
                
                PasswordField(
                    password: $viewModel.userInfo.password,
                    isCheckingMismatch: $viewModel.isCheckingMismatch
                )
                .submitLabel(.done)
                .focused($focusedField, equals: .password)
                .onChange(of: viewModel.userInfo.password) { ///비밀번호가 입력될 때마다 isCheckingMismatch를 false로 바꿈
                    viewModel.isCheckingMismatch = false ///비밀번호를 다시 입력할 때 border라인을 원래 상태로 돌리기 위함임
                }
                .padding(.bottom, 29)
                
                
                //FIXME: - isDisabled 수정
                //FIXME: - 이메일, 비밀번호 확인 로직 들어가야 함
                OkButton(title: "확인", isDisabled: false) {
                    isLoading = true
                    Task { @MainActor in
                        do {
                            let token = try await viewModel.login() ///로그인 성공하면 토큰을 응답으로 받음 (TokenInfo)
                            let success = KeychainManager.standard.saveSession(token, for: "tokenInfoKey")
                            /// token ; 받은 토큰을 Keychain에 저장 +  success ; 성공 여부를 success에 저장 (Bool)
                            
                            if success {
                                print("토큰 저장 성공")
                            } else {
                                print("토큰 저장 실패")
                            }
                            await authViewModel.checkLoginStatus()
                            switch authViewModel.state {
                            case .unknown: /// 이 케이스는 어떻게 처리할까?
                                print("")
                                isLoading = false
                            case .loggedIn:
                                // 로그인 성공 직후 홈 진입 전에 필요한 데이터 프리로드
                                async let nicknameTask: () = onboardingViewModel.fetchNicknameIfNeeded()
                                async let zoneTask: () = homeViewModel.fetchZone(size: 1)
                                await nicknameTask
                                await zoneTask
                                selectedIndex = 0
                                isLoading = false
                            case .needsOnboarding:
                                selectedIndex = 13
                                isLoading = false
                            case .loggedOut:
                                loginFailed = true
                                isLoading = false
                            }
                        } catch {
                            viewModel.isCheckingMismatch = true ///0806 추가
                            loginFailed = true
                            isLoading = false
                        }
                    }
                }
                .padding(.bottom, 15)
                
                signUporFindPwdButton
                    .padding(.bottom, 69)
                
                easyLoginBar
                    .padding(.bottom, 24)
                
                SNSloginButtonView()
                //.padding(.bottom, 131)
            } //v
            .padding(.horizontal, 20)
            .disabled(isLoading)
            /*
            .alert("로그인 실패", isPresented: $loginFailed) {
                Button("확인", role: .cancel) { }
            } message: {
                Text("이메일 또는 비밀번호를 확인해주세요.")
            }
             */
            if isLoading {
                Color("black").opacity(0.1).ignoresSafeArea()
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .loading))
                    .scaleEffect(1.5)
            }
        }
    }

    // MARK: - 로그인 하위 뷰

    private var headerIcon: some View {
        VStack(alignment: .center) {
            Image("waybleLogo3")
                .resizable()
                .frame(width: 70, height: 50)
            Text("Wayble")
                .font(.mainTextBold20)
        }
    }

    // MARK: - 비밀번호 찾기 | 회원가입 페이지 이동 버튼
    private var signUporFindPwdButton: some View {
        HStack(alignment: .center, spacing: 0) {
            Spacer()
            Button(action: {}) {
                Text("비밀번호 찾기")
                    .font(.mainTextSemibold12)
                    .foregroundStyle(Color("gray-900"))
                    .tracking(-0.24)
            }
            Text("|")
                .foregroundStyle(Color("gray-900"))
                .padding(.horizontal, 4)
            Button(action: { selectedIndex = 14 }) {
                Text("회원가입")
                    .font(.mainTextSemibold12)
                    .foregroundStyle(Color("gray-900"))
                    .tracking(-0.24)
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
    }

    private var easyLoginBar: some View {
        HStack(alignment: .center) {
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color("gray-300"))
            Text("간편 로그인 하기")
                .font(.mainTextRegular12)
                .foregroundStyle(Color("gray-700"))
                .tracking(-0.24)
                .padding(.horizontal, 8)
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color("gray-300"))
        }
    }
}

// FIXME: - 이미지 교체, 기능 추가해야 함
/// 간편 로그인 버튼 (sdk 사용해서 구현해야 함)
struct SNSloginButtonView: View {
    @Environment(NavigationRouter.self) private var router
    var body: some View {
        HStack {
            Button(action: {}) {
                Image("kakaoIcon")
                    .resizable()
                    .frame(width: 52, height: 52)
            }
            Button(action: {}) {
                Image("appleIcon")
                    .resizable()
                    .frame(width: 52, height: 52)
            }
        }
    }
}
