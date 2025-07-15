//
//  ResetPasswordView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/15/25.
//

import SwiftUI

struct ResetPasswordView: View {
    @State var signviewModel = SignupViewModel()
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            BackButton()
                .padding(.top, 30)
                .padding(.bottom, 27)
            TitleText(text: "새로운 비밀번호를\n설정해 주세요")
                .padding(.bottom, 48)
            
            //FIXME: - PasswordField 수정
            PasswordField(password: $signviewModel.signupModel.password, storedPassword: "", isCheckingMismatch: false)
            
            //FIXME: - PasswordField 수정
            PasswordField(password: $signviewModel.signupModel.password, storedPassword: "", isCheckingMismatch: false)
            
            
            
            Spacer()
            OkButton(title: "확인", isDisabled: false) {
                print("아이디 생성")
            }
            .padding(.bottom, 54)
            
        }
    }
}

#Preview {
    ResetPasswordView()
}
