//
//  VerifyCodeView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/15/25.
//


//TODO: - 인증코드 컴포넌트 만들기

import SwiftUI

struct VerifyCodeView: View {


    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            BackButton()
                .padding(.top, 30)
                .padding(.bottom, 27)
            TitleText(text: "해당 이메일 주소로\n인증코드를 발송했어요")
                .padding(.bottom, 48)
            //EmailField(email: $signviewModel.signupModel.email, storedEmail: "", isCheckingMismatch: false)
            
            Spacer()
            OkButton(title: "확인", isDisabled: false) {
                print("아이디 생성")
            }
            .padding(.bottom, 54)
            
        }
    }
}

#Preview {
    VerifyCodeView()
        .environment(NavigationRouter())
}
