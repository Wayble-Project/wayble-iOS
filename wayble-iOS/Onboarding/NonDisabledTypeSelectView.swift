//
//  NonDisabledTypeSelectView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/18/25.
//

//FIXME: - onPreviousAction 설정
import SwiftUI

struct NonDisabledTypeSelectView: View {
    @Bindable var viewModel: OnboardingViewModel
    @Binding var step: Int
    @Binding var selectedIndex: Int
    
    let options: [String] = ["동행인", "일반 사용자"]
    @Binding var selectedItem: String?
    
    
    var body: some View {
        
        
        VStack(alignment: .leading, spacing: 0) {
            OnboardingBar(currentStep: $step)
                .padding(.top, 21)
                .padding(.bottom, 55)
                .padding(.horizontal, 7)
            
            TitleText(text: "해당하는 항목을 선택해주세요")
                .padding(.bottom, 74)
                .padding(.horizontal, 7)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 2), spacing: 0) {
                ForEach(options, id: \.self) { option in
                    MultipleSelectButton(
                        title: option,
                        isSelected: selectedItem == option
                    ) {
                        if selectedItem == option { //선택이 된 상태에서
                            selectedItem = nil // 또 선택하면 선택 해제
                        } else {
                            selectedItem = option
                        }
                    }
                }
            }
            Spacer()
            BothButton(
                step: $step,
                selectedIndex: $selectedIndex,
                isNextDisabled: selectedItem == nil,
                onPreviousAction: {
                    resetNonDisabledSelection()
                },
                onNextAction: {
                    guard let selected = selectedItem else {
                        print("❌ 항목 선택 필요")
                        return ///사용자가 아무 항목도 선택하지 않았을 경우, 다음 화면으로 넘어가지 않고 리턴
                    }
                    viewModel.userInfo.isWithCompanion = (selected == "동행인")
                    step += 1
                }
            )
            .padding(.horizontal, 7)
        } //v
        .padding(.horizontal, 13)
        .onAppear { resetNonDisabledSelection() }
    }
    
    private func resetNonDisabledSelection() {
        selectedItem = nil
    }
}
