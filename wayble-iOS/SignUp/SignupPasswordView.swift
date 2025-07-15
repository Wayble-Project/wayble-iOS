//
//  SignupPasswordView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/15/25.
//

import SwiftUI






//FIXME: -비밀번호 필드 컴포넌트 와프 관련 답변 대기 중
//FIXME: - 가입 UserInfo 모델을 만들고 signviewModel 수정

import SwiftUI

struct SignupPasswordView: View {
    @State var signviewModel = SignupViewModel()
    @State var confirmPassword: String
    
    @State private var isPasswordMatched: Bool = false
    
    @AppStorage("password") var password: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            BackButton()
                .padding(.top, 30)
                .padding(.bottom, 27)
            TitleText(text: "로그인에 사용할\n비밀번호를 입력해 주세요")
                .padding(.bottom, 48)
            
            //FIXME: - PasswordField 수정
            SetPasswordField(
                password:
                    $signviewModel.signupModel.password,
                confirmPassword:
                    $confirmPassword,
                isMatched: .constant(true),
                setPassword: "1",
                content: "✓ 대소문자,숫자,특수문자 포함",
                shouldCheckMatch: false)
            
            .padding(.bottom, 18)
            
            //FIXME: - setPassword 파라미터 이렇게 둬도 되나?
            SetPasswordField(
                password: $confirmPassword,
                confirmPassword: $signviewModel.signupModel.password,
                isMatched: $isPasswordMatched,
                setPassword: "1",
                content: "✓ 비밀번호 일치"
            )
            
            Spacer()
            OkButton(
                title: "확인",
                isDisabled: !isPasswordMatched
            ) {
                print("비밀번호 생성")
            }
            .padding(.bottom, 54)
            
        }
    }
}

#Preview {
    SignupPasswordView(confirmPassword: "")
        .environment(NavigationRouter())
}
