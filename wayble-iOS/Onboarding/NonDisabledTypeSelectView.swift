//
//  NonDisabledTypeSelectView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/18/25.
//

//FIXME: - rootView에서 userInfo 값이 장애인 / 비장애인 따라 다음 뷰 결정
import SwiftUI

struct NonDisabledTypeSelectView: View {
    @Binding var step: Int
    @State var userInfoViewModel = UserInfoViewModel()
    
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
        } //v
        .padding(.horizontal, 13)
    }
}

#Preview {
    PreviewWrapper()
}

private struct PreviewWrapper: View {
    @State var step = 2
    @State var selected: String? = nil

    var body: some View {
        NonDisabledTypeSelectView(
            step: $step,
            selectedItem: $selected
        )
    }
}
