//
//  SignupEmailView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/14/25.
//


//FIXME: - 가입 UserInfo 모델? signupModel 완성하고 signviewModel 수정
import SwiftUI

struct SignupEmailView: View {
    @Bindable var viewModel: SignupViewModel
    @Binding var selectedIndex: Int
    
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
                viewModel.userInfo.email = viewModel.userInfo.email //명시..
                print("📧 입력된 이메일:", viewModel.userInfo.email)
                print("✅ 이메일 유효성 검사:", viewModel.isEmailValid)
                selectedIndex = 9
            }
            .padding(.bottom, 54)
            
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    SignupEmailView(viewModel: SignupViewModel(), selectedIndex: .constant(0))
}
