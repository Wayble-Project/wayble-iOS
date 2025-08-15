//
//  SignupCompletedView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/14/25.
//

import SwiftUI


//FIXME: - MP4View 크기 조정 -> Figma 어떻게 봐야할지 모르겠음
//FIXME: - OkButton - isDisabled 바꾸기 -> 에러처리

struct SignupCompletedView: View {
    
    @Bindable var viewModel: SignupViewModel
    @Binding var selectedIndex: Int
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                GeometryReader { geo in
                    MP4View(filename: "Join", fileExtension: "mp4", size: geo.size)
                        .frame(height: 500)
                        .clipped()
                }
                .frame(height: 600)
                
                TitleText(text: "환영합니다\n가입이 완료되었어요!", alignment: .center)
                    //.padding(.bottom, 48)
            }
            //.border(Color.black)
            
            Spacer()
            
            OkButton(title: "확인", isDisabled: false) {
                viewModel.signup { success in
                    if success {
                        selectedIndex = 7
                    } else {
                        print("회원가입 오류")
                    }
                }
            }
            .padding(.bottom, 54)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    SignupCompletedView(viewModel: SignupViewModel(), selectedIndex: .constant(0))
}
