//
//  UserInfoInputView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/15/25.
//

import SwiftUI

struct GenderBirthStepView: View {
    @Bindable var viewModel: OnboardingViewModel
    @Binding var step: Int
    @Binding var selectedIndex: Int
    
    @Binding var selectedItem: String?
    
    
    let option = ["남성", "여성", "선택 안 함"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            OnboardingBar(currentStep: $step)
                .padding(.top, 21)
                .padding(.bottom, 55)
            TitleText(text: "성별과 생년월일을 입력해주세요", alignment: .leading)
                .padding(.bottom, 78)
            SingleSelectThreeGridView(options: option, selectedItem: $selectedItem)
                .padding(.bottom, 21)
            CustomTextField(
                text: "생년월일",
                placeHolder: "YYYY-MM-DD",
                textValue: $viewModel.userInfo.birth,
                keyboardType: .default,
                validationState: $viewModel.birthValidationState
            )
            Spacer()
            BothButton(
                step: $step,
                selectedIndex: $selectedIndex,
                //isNextDisabled: (selectedItem == nil)||(viewModel.userInfo.birth.isEmpty),
                isNextDisabled: (selectedItem == nil) || !viewModel.isBirthValid,
                onPreviousAction: {
                    selectedItem = nil
                    viewModel.userInfo.birth = ""
                },
                onNextAction: {
                    viewModel.birthValidationState = viewModel.checkBirthState
                    guard let selected = selectedItem,
                          let gender = Gender(rawValue: selected)
                    else { return }
                    viewModel.userInfo.birth = viewModel.userInfo.birth.trimmingCharacters(in: .whitespacesAndNewlines)
                    viewModel.userInfo.gender = gender
                }
            )
        } //v
        .padding(.horizontal, 20)
    }
}
