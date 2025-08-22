//
//  MultipleSelectButton.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/17/25.
//

import SwiftUI

//MARK: - 버튼 1개 선택 뷰

struct MultipleSelectButton: View {
    var spacing: Double = 7
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.mainTextSemibold16)
                .tracking(-0.32)
                .foregroundStyle(isSelected ? Color("blue-900") : Color("black"))
                .frame(maxWidth: .infinity)
                .frame(height: 108)
                .background((isSelected ? Color("blue-50") : Color.white))
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(isSelected
                                ? Color("blue-500")
                                : Color("gray-300"),
                                lineWidth: 2
                               )
                )
        }
        .padding(.horizontal, spacing)
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

// MARK: - 단일 3열 선택 버튼

struct SingleSelectThreeGridView: View {
    let options: [String]
    @Binding var selectedItem: String? //현재 선택된 항목을 나타내는 단일 값 바인딩

    private let columns: [GridItem] = Array(repeating: GridItem(.flexible(), spacing: 0), count: 3)
    // 3개의 열, 간격은 0

    var body: some View {
        LazyVGrid(columns: columns, spacing: 0) {
            ForEach(options, id: \.self) { option in
                MultipleSelectButton(
                    spacing: 5,
                    title: option,
                    isSelected: selectedItem == option
                ) {
                    if selectedItem == option {
                        selectedItem = nil
                    } else {
                        selectedItem = option
                    }
                }
            }
        }
        .padding(.horizontal, -5)
    }
}




/*
#Preview {
    @Previewable @State var selectedDisabilities: Set<String> = []
    SelectableGridView(options: ["발달장애", "시각장애", "지체장애", "청각장애"], selectedItems: $selectedDisabilities)
}
 */

#Preview {
    //@Previewable @State var selectedDisabilities: Set<String> = []
    @Previewable @State var selectedGender: String? = nil
    
    SingleSelectThreeGridView(
        options: ["남성", "여성", "선택 안 함"],
        selectedItem: $selectedGender
    )
}
