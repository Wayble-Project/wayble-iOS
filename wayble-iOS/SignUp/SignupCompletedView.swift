//
//  SignupCompletedView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/14/25.
//

import SwiftUI


//FIXME: - image 변경해야 함

struct SignupCompletedView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image("check02")
                .resizable()
                .frame(width: 33, height: 33)
                .padding(.bottom, 50.4)
            TitleText(text: "환영합니다\n가입이 완료되었어요!", alignment: .center)
            
            Spacer()
            
            OkButton(title: "확인", isDisabled: false) {
                print("appstorge 저장하는 코드")
            }
            .padding(.bottom, 54)
        }
    }
}

#Preview {
    SignupCompletedView()
}
