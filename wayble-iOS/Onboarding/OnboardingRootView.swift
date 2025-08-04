//
//  OnboardingRootView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/16/25.
//

import SwiftUI

//TODO: - case 2 뷰 수정하기 / case 3 , 완료 화면 완성하기

struct OnboardingRootView: View {
    @Environment(NavigationRouter.self) private var router
    @Bindable var viewModel: OnboardingViewModel
    @State var step = 0
    @Binding var selectedIndex: Int
    @State private var selectedUserType: String? = nil
    @State private var selectedGender: String? = nil

    var body: some View {
        VStack {
            switch step {
            case 0:
                NicknameStepView(viewModel: viewModel, step: $step, selectedIndex: $selectedIndex)
            case 1:
                GenderBirthStepView(viewModel: viewModel , step: $step, selectedIndex: $selectedIndex, selectedItem: $selectedGender)
            case 2:
                UserTypeSelectView(viewModel: viewModel, step: $step,
                                   selectedIndex: $selectedIndex, selectedItem: $selectedUserType)
            case 3:
                if selectedUserType == "장애인" {
                        DisabilityTypeSelectView(viewModel: viewModel,step: $step, selectedIndex: $selectedIndex)
                    }
                else {
                    NonDisabledTypeSelectView(viewModel: viewModel, step: $step, selectedIndex: $selectedIndex, selectedItem: $selectedUserType)
                }
                        
            default:
                EmptyView()
            }
            //BothButton(step: $step)
            //.padding(.horizontal, 20)
        }
    }
}

