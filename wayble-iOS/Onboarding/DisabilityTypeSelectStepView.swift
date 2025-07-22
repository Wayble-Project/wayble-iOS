//
//  DisabilityTypeSelectView .swift
//  wayble-iOS
//
//  Created by 이서현 on 7/15/25.
//

//TODO: - 변수 - UserInfo에 있는 변수 연결하기


import SwiftUI

struct DisabilityTypeSelectView: View {
    @Binding var step: Int
    @Bindable var viewModel = OnboardingViewModel()
    
    @State private var selectedDisabilities: Set<String> = []
    @State private var selectedAssistTools: Set<String> = []

    let disabilityOptions =
    ["발달장애", "시각장애", "지체장애", "청각장애"]
    let assistToolOptions =
    ["안내견", "지팡이", "휠체어", "없음"]

    
    var body: some View {
        VStack(spacing: 0) {
            OnboardingBar(currentStep: $step)
                .padding(.top, 21)
                .padding(.bottom, 55)
                .padding(.horizontal, 20)

            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    TitleText(text: "해당하는 항목을 선택해주세요")
                        .padding(.bottom, 41)
                        .padding(.horizontal, 7)

                    VStack(alignment: .leading, spacing: 0) {
                        Text("장애 유형")
                            .font(.mainTextSemibold16)
                            .foregroundStyle(Color.gray900)
                            .tracking(-0.32)
                            .frame(height: 22)
                            .padding(.bottom, 11)
                            .padding(.horizontal, 7)
                        SelectableGridView(options: disabilityOptions, selectedItems: $selectedDisabilities)
                    }
                    .padding(.bottom, 55)

                    VStack(alignment: .leading, spacing: 0) {
                        Text("이동보조수단")
                            .font(.mainTextSemibold16)
                            .foregroundStyle(Color.gray900)
                            .tracking(-0.32)
                            .frame(height: 22)
                            .padding(.bottom, 11)
                            .padding(.horizontal, 7)
                        SelectableGridView(options: assistToolOptions, selectedItems: $selectedAssistTools)
                    }
                    .padding(.bottom, 72)

                    Spacer()
                    BothButton(
                        step: $step,
                        isNextDisabled: selectedDisabilities.isEmpty || selectedAssistTools.isEmpty,
                        onNextAction: {
                            viewModel.userInfo.disabilityType = selectedDisabilities.compactMap { UserInfo.DisabilityType(rawValue: $0) }
                            viewModel.userInfo.mobilityAid = selectedAssistTools.compactMap { UserInfo.MobilityAid(rawValue: $0) }
                                }
                    )
                    .padding(.horizontal, 7)
                    
                }
                
            }

        }
        .padding(.horizontal, 13)
    }
}
