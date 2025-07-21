//
//  SetNicknameView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/15/25.
//


//FIXME: - 이전버튼 viewModel.userInfo.nickname = "" 만 해도 충분한지
import SwiftUI

struct NicknameStepView: View {
    @Binding var step: Int
    @Bindable var viewModel = OnboardingViewModel()
    
    @Environment(NavigationRouter.self) private var router
    
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
                textValue: $viewModel.userInfo.nickname,
                keyboardType: .default
            )
            Spacer()
            BothButton(
                step: $step,
                isNextDisabled: viewModel.userInfo.nickname.count < 2,
                onPreviousAction: {
                    viewModel.userInfo.nickname = ""
                    router.push(.login)
                }
            )
            
        } //v
        .padding(.horizontal, 20)
    }
}
