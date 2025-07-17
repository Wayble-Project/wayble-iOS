//
//  UserTypeSelectView .swift
//  wayble-iOS
//
//  Created by 이서현 on 7/15/25.
//

//TODO: - 뷰 디테일 구현하기
import SwiftUI

struct UserTypeSelectView: View {
    let options: [String]
    @Binding var selectedItem: String?
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            TitleText(text: "해당하는 항목을 선택해주세요")
                .padding(.bottom, 41)
                .padding(.horizontal, 7)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 14), count: 2), spacing: 0) {
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
            .padding(.horizontal, 7)
        }
    }
}



#Preview {
    PreviewWrapper()
}

private struct PreviewWrapper: View {
    @State var selected: String? = nil
    
    var body: some View {
        UserTypeSelectView(
            options: ["장애인", "비장애인"],
            selectedItem: $selected
        )
    }
}
