//
//  SignupEmailView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/14/25.
//

import SwiftUI

struct IDsignupView: View {
    @State var signviewModel = SignupViewModel()
    
    @AppStorage("email") var email: String = ""


    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            BackButton()
                .padding(.top, 30)
                .padding(.bottom, 27)
            TitleText(text: "로그인에 사용할\n아이디를 입력해 주세요")
                .padding(.bottom, 48)
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
    IDsignupView()
        .environment(NavigationRouter())
}
