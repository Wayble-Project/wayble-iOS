//
//  NewPasswordCompletedView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/15/25.
//


//FIXME: - 이미지 바꾸기 , 확인 네비게이션
import SwiftUI

struct NewPasswordCompletedView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image("check02")
                .resizable()
                .frame(width: 33, height: 33)
                .padding(.bottom, 50.4)
            TitleText(text: "새로운 비밀번호가\n설정되었습니다!", alignment: .center)
            
            Spacer()
            
            OkButton(title: "확인", isDisabled: false) {
                print("appstorge 저장하는 코드")
            }
            .padding(.bottom, 54)
        }
    }
}

#Preview {
    NewPasswordCompletedView()
}
