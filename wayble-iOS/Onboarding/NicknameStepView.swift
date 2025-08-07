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
                keyboardType: .default,
                validationState: .constant(.valid)
            )
            Spacer()
            BothButton(
                step: $step,
                selectedIndex: $selectedIndex,
                isNextDisabled: viewModel.userInfo.nickname.trimmingCharacters(in: .whitespacesAndNewlines).count < 2,
                onPreviousAction: {
                    viewModel.userInfo.nickname = ""
                    selectedIndex = 8
                },
                onNextAction: {
                    Task {
                        let trimmed = viewModel.userInfo.nickname.trimmingCharacters(in: .whitespacesAndNewlines)

                        do {
                            await viewModel.checkNicknameDuplicate(nickname: trimmed)
                            viewModel.nicknameValidationState = viewModel.checkNicknameState

                            guard let isDuplicate = viewModel.isNicknameDuplicate else {
                                print("❌ 중복 확인 실패 (nil)")
                                return
                            }

                            if isDuplicate {
                                print("❌ 중복된 닉네임입니다.")
                                return
                            }

                            viewModel.userInfo.nickname = trimmed
                            print("✅ 닉네임 : \(viewModel.userInfo.nickname)")
                            step += 1

                        }
                    }
                }
            )
            
        } //v
        .padding(.horizontal, 20)
    }
}
