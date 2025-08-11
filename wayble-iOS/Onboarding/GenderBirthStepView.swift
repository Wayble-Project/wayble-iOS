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
                isNextDisabled: (selectedItem == nil) || !viewModel.isBirthValid || viewModel.userInfo.birth.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                onPreviousAction: {
                    selectedItem = nil
                    viewModel.userInfo.birth = ""
                },
                onNextAction: {
                    print("✅ 버튼 눌림")
                    viewModel.birthValidationState = viewModel.checkBirthState
                    viewModel.handleGender(genderString: selectedItem) ///0808 ui에서 버튼 선택(남성,여성,선택 안 함 선택지)
                    ///UI 입력값들 → 내부 상태로 바꿔주는 처리(handle) 함수
                    step += 1
                    print("✅ step 증가: \(step)")
                }
            )
        } //v
        .padding(.horizontal, 20)
    }
}
