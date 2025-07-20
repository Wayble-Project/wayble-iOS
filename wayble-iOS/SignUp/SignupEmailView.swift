//
//  SignupEmailView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/14/25.
//


//FIXME: - 가입 UserInfo 모델? signupModel 완성하고 signviewModel 수정
import SwiftUI

struct SignupEmailView: View {
    @State var viewModel = SignupViewModel()
    
    //@AppStorage("email") var email: String = ""


    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            BackButton()
                .padding(.top, 30)
                .padding(.bottom, 27)
            TitleText(text: "로그인에 사용할\n아이디를 입력해 주세요")
                .padding(.bottom, 48)
            EmailField(email: $viewModel.userInfo.email, storedEmail: "", isCheckingMismatch: viewModel.isChecking)
                .onChange(of: viewModel.userInfo.email) {
                    viewModel.validateEmailFormat()
                }
            
            Spacer()
            OkButton(title: "확인", isDisabled: !viewModel.isEmailValid || viewModel.isChecking) {
                //viewModel.checkEmailDuplication()
            }
            .padding(.bottom, 54)
            
        }
    }
}

#Preview {
    SignupEmailView()
        .environment(NavigationRouter())
}
