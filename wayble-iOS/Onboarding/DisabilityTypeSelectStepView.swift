//
//  DisabilityTypeSelectView .swift
//  wayble-iOS
//
//  Created by 이서현 on 7/15/25.
//

//FIXME: - 온보딩 바 - 인덱스 연결해서 페이지 넘기면 색상 채워지게
//TODO: - 변수 - UserInfo에 있는 변수 연결하기


import SwiftUI

struct DisabilityTypeSelectView: View {
    @State private var selectedDisabilities: Set<String> = []
    @State private var selectedAssistTools: Set<String> = []

    let disabilityOptions =
    ["발달장애", "시각장애", "지체장애", "청각장애"]
    let assistToolOptions =
    ["안내견", "지팡이", "휠체어", "없음"]

    
    var body: some View {
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

            Spacer()
        }
        .padding(.horizontal, 13)
    }
}


#Preview {
    DisabilityTypeSelectView()
}
