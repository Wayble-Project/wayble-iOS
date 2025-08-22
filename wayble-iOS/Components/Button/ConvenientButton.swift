//
//  ConvenientButton.swift
//  wayble-iOS
//
//  Created by 이서현 on 8/11/25.
//

import SwiftUI

struct ConvenientButton: View {
    let title: String
    let icon: String
    var isSelected: Bool
    var action: () -> Void
    
    private var backgroundColor: Color {
        if isSelected {
            return Color.white
        } else {
            return Color("gray-100")
        }
    }
    
    private var textColor: Color {
        if isSelected {
            return Color("darkblue-500")
        } else {
            return Color("gray-500")
        }
    }
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 5) {
                Image(icon)
                    .renderingMode(.template) ///아이콘처럼 색상을 코드에서 제어하고 싶을 때(이미지 색 말고 내가 지정한 색으로)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 18)
                Text(title)
                    .font(.mainTextSemibold14)
                    .tracking(-0.28)
            }
            .foregroundStyle(textColor)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(
                RoundedRectangle(cornerRadius: 40)
                    .fill(backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .stroke(
                                isSelected ? Color("darkblue-500") : Color.clear, lineWidth: 1)
                    )
            )
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        ConvenientButton(title: "경사로", icon: "chair01", isSelected: true, action: {})
        ConvenientButton(title: "경사로", icon: "chair01", isSelected: false, action: {})
    }
}
