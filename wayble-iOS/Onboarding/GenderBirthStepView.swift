//
//  UserInfoInputView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/15/25.
//

import SwiftUI

struct GenderBirthStepView: View {
    @Binding var step: Int
    @State var userInfoViewModel = UserInfoViewModel()
    
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
                textValue: $userInfoViewModel.userInfo.birth,
                keyboardType: .default
            )
            Spacer()
            //BothButton(step: $step)
            
        } //v
        .padding(.horizontal, 20)
    }
}
