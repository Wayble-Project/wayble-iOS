//
//  SetNicknameView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/15/25.
//


//FIXME: - 이전버튼 viewModel.userInfo.nickname = "" 만 해도 충분한지
import SwiftUI

struct NicknameStepView: View {
    @Bindable var viewModel: OnboardingViewModel
    @Binding var step: Int
    @Binding var selectedIndex: Int

    
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
                selectedIndex: $selectedIndex,
                isNextDisabled: !viewModel.isNicknameValid,
                onPreviousAction: {
                    viewModel.userInfo.nickname = ""
                    selectedIndex = 8
                },
                onNextAction: {
                    viewModel.userInfo.nickname = viewModel.userInfo.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
                    /// .trimmingCharacters(in: .whitespacesAndNewlines) : 앞뒤의 공백(space), 탭, 줄바꿈(\n) 같은 쓸데없는 문자들을 제거해주는 Swift 표준 함수
                    print("닉네임 : \(viewModel.userInfo.nickname)")
                }
            )
            
        } //v
        .padding(.horizontal, 20)
    }
}
