//
//  SignupTermsView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/14/25.
//

import SwiftUI

struct SignupTermsView: View {
   @State private var isChecked: Bool = false
    @Binding var selectedIndex: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            BackButton(action: {
                selectedIndex = 7
            })
                .padding(.top, 30)
                .padding(.bottom, 27)
            TitleText(text: "wayble 이용 약관에\n동의해 주세요")
                .padding(.bottom, 48)
            
            //FIXME: - 토글 버튼 이미지 전환 (색)
            HStack(spacing: 0) {
                Button(action: {
                    isChecked.toggle()
                }) {
                    Image(isChecked ? "check05" : "check01")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                Text("웨이블 서비스 이용 동의")
                    .font(.mainTextSemibold14)
                    .foregroundStyle(Color.black)
                    .padding(.leading, 12)
            }
            .padding(.bottom, 9)
            
            Text("가입 약관 내용 추가")
                .font(.mainTextRegular14)
                .foregroundStyle(Color.black)
                .padding(.leading, 36)
            
            Spacer()
            OkButton(title: "확인", isDisabled: !isChecked) {
                selectedIndex = 8
            }
            .padding(.bottom, 54)
            
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    SignupTermsView(selectedIndex: .constant(0))
        .environment(NavigationRouter())
}
