//
//  LoginView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/14/25.
//

import SwiftUI


struct LoginView: View {
    
    enum Field {
        case email
        case password
    }

    @Environment(NavigationRouter.self) private var router
    @FocusState private var focusedField: Field?
    //@State var email: String
    @State var loginViewModel = LoginViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            headerIcon
                .padding(.bottom, 35)
            
            EmailField(
                email: $loginViewModel.email,
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
                password: $loginViewModel.pwd,
                storedPassword: "12345678",
                isCheckingMismatch: false
            )
            .submitLabel(.done)
            .focused($focusedField, equals: .password)
            .onSubmit {
                loginViewModel.login()
            }
            .padding(.bottom, 29)
            
            
            //FIXME: - 이메일 패스워드 텍스트 필드 값 따라 액션 변경
            OkButton(title: "확인", isDisabled: false) {
                print("확인")
                router.push(.home)
                
            }
            .padding(.bottom, 15)
            
            signUporFindPwdButton
                .padding(.bottom, 69)
            
            easyLoginBar
                .padding(.bottom, 24)
            
            SNSloginButtonView()
                //.padding(.bottom, 131)
        } //v
    }
    
    
    
    // MARK: - 로그인 하위 뷰
    
    private var headerIcon: some View {
        VStack(alignment: .center) {
            Image("waybleLogo3")
                .resizable()
                .frame(width:70, height: 50)
            Text("Wayble")
                .font(.mainTextBold20)
        }
    }
    
    
    private var signUporFindPwdButton: some View {
        HStack(alignment: .center, spacing: 0) {
            Spacer()
            Button(action: {router.push(.findPassword)}) {
                Text("비밀번호 찾기")
                    .font(.mainTextSemibold12)
                    .foregroundStyle(Color.gray900)
                    .tracking(-0.24)
            }
            
            Text("|")
                .foregroundStyle(.gray900)
                .padding(.horizontal, 4)
            
            
            Button(action: {router.push(.signup)}) {
                Text("회원가입")
                    .font(.mainTextSemibold12)
                    .foregroundStyle(Color.gray900)
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
                .foregroundStyle(Color.gray300)
            
            Text("간편 로그인 하기")
                .font(.mainTextRegular12)
                .foregroundStyle(Color.gray700)
                .tracking(-0.24)
                .padding(.horizontal, 8)
            
            Rectangle()
                .frame(height: 1)
                .foregroundStyle(Color.gray300)
        }
        .padding(.horizontal, 20)
    }
    
}

//FIXME: - 이미지 교체, 기능 추가해야 함

struct SNSloginButtonView : View {
    
    @Environment(NavigationRouter.self) private var router
    
    var body: some View {
        HStack {
            Button(action: {}) {
                Image("home")
                    .resizable()
                    .frame(width: 52, height: 52)
            }
            
            Button(action: {}) {
                Image("home")
                    .resizable()
                    .frame(width: 52, height: 52)
            }
            
        }
    }
}




#Preview {
    LoginView()
        .withRouter()
}
