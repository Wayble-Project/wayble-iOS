//
//  UserTypeSelectView .swift
//  wayble-iOS
//
//  Created by 이서현 on 7/15/25.
//

//TODO: - 뷰 디테일 구현하기 / BothButton 에 padding 7 주는 거 맞는지 확인
import SwiftUI

struct UserTypeSelectView: View {
    @Binding var step: Int
    @Bindable var viewModel = OnboardingViewModel()
    
    let options: [String] = ["장애인", "비장애인"]
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
                    MultipleSelectButton(title: option,
                                         isSelected: selectedItem == option) {
                        if selectedItem == option {
                            selectedItem = nil
                        } else {
                            selectedItem = option
                        }
                    }
                }
            }
            Spacer()
            BothButton(
                step: $step,
                isNextDisabled: selectedItem == nil,
                onPreviousAction: {
                    selectedItem = nil
                },
                onNextAction: {
                    viewModel.userInfo.hasDisability = (selectedItem == "장애인")
                }
            )
            .padding(.horizontal, 7)
        } //v
        .padding(.horizontal, 13)
    }
}


/*
#Preview {
    PreviewWrapper()
        .withRouter()
}

private struct PreviewWrapper: View {
    @State var selected: String? = nil
    
    var body: some View {
        UserTypeSelectView(
            step: $step, options: ["장애인", "비장애인"],
            selectedItem: $selected
        )
    }
}
*/
