//
//  findPWDView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/15/25.
//


//FIXME: - 이메일 텍스트필드 수정해야 함

import SwiftUI

struct findPasswordView: View {
    @State var signviewModel = SignupViewModel()
    


    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            BackButton()
                .padding(.top, 30)
                .padding(.bottom, 27)
            TitleText(text: "이메일 주소로\n비밀번호를 찾을 수 있어요")
                .padding(.bottom, 48)
            
            //FIXME: - EmailField 수정
            EmailField(email: $signviewModel.signupModel.email, storedEmail: "", isCheckingMismatch: false)
            
            Spacer()
            OkButton(title: "확인", isDisabled: false) {
                print("아이디 생성")
            }
            .padding(.bottom, 54)
            
        }
    }
}

#Preview {
    findPasswordView()
        .environment(NavigationRouter())
}
