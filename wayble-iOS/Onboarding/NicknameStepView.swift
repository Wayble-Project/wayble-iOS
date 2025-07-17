//
//  SetNicknameView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/15/25.
//

import SwiftUI

struct NicknameStepView: View {
    @State var step = 0
    @State var userInfoViewModel = UserInfoViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            OnboardingBar(currentStep: $step)
                .padding(.top, 21)
                .padding(.bottom, 55)
            TitleText(text: "닉네임을 설정해주세요", alignment: .leading)
                .padding(.bottom, 84)
            CustomTextField(
                text: "닉네임",
                placeHolder: "닉네임을 입력해주세요",
                textValue: $userInfoViewModel.userInfo.nickname,
                keyboardType: .default
            )
            Spacer()
            BothButton()
            
        } //v
        .padding(.horizontal, 20)
    }
}

#Preview {
    NicknameStepView()
}
