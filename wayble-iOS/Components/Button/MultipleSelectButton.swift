//
//  MultipleSelectButton.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/17/25.
//

import SwiftUI

//MARK: - 버튼 1개 선택 뷰

struct MultipleSelectButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.mainTextSemibold16)
                .tracking(-0.32)
                .foregroundStyle(isSelected ? Color.blue900 : .black)
                .frame(maxWidth: .infinity)
                .frame(height: 128)
                .background(isSelected ? Color.blue50 : Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(isSelected
                                ? Color.blue500
                                : Color.gray300,
                                lineWidth: 2
                               )
                )
        }
        .padding(.horizontal, 7)
    }
}

//MARK: - 다중 2*2 선택 버튼

struct SelectableGridView: View {
    let options: [String]
    @Binding var selectedItems: Set<String>
    let columns = [
        GridItem(.flexible(), spacing: 0),
        GridItem(.flexible(), spacing: 0)
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 14) {
            ForEach(options, id: \.self) { option in
                MultipleSelectButton(
                    title: option,
                    isSelected: selectedItems.contains(option)
                ) {
                    if selectedItems.contains(option) {
                        selectedItems.remove(option)
                    }
                    else {
                        selectedItems.insert(option)
                    }
                }
            }
        }
    }
}

//MARK: - 단일 2열 선택 버튼

struct SelectGridView: View {
    let options: [String]
    @Binding var selectedItem: String?
    
    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 0), count: 2)
    
    //columns: LazyVGrid에서 두 열로 구성되도록 설정

    var body: some View {
        LazyVGrid(columns: columns, spacing: 0) {
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
    }
}

#Preview {
    @Previewable @State var selectedDisabilities: Set<String> = []
    SelectableGridView(options: ["발달장애", "시각장애", "지체장애", "청각장애"], selectedItems: $selectedDisabilities)
}
