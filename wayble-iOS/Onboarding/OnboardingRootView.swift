//
//  OnboardingRootView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/16/25.
//

import SwiftUI

//TODO: - case 2 뷰 수정하기 / case 3 , 완료 화면 완성하기

struct OnboardingRootView: View {
    @State private var step = 0
    @State private var selectedUserType: String? = nil
    @State private var selectedGender: String? = nil

    var body: some View {
        VStack {
            switch step {
            case 0:
                NicknameStepView(step: $step)
            case 1:
                GenderBirthStepView(step: $step, selectedItem: $selectedGender)
            case 2:
                UserTypeSelectView(step: $step,
                                   selectedItem: $selectedUserType)
            case 3:
                DisabilityTypeSelectView(step: $step)
            default:
                EmptyView()
            }
            BothButton(step: $step)
                .padding(.horizontal, 20)
        }
    }
}

#Preview {
    OnboardingRootView()
}
