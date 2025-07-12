//
//  OkButton.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/12/25.
//

import SwiftUI

struct OkButtonStyle: ButtonStyle {
    var isDisabled: Bool = true

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.mainTextSemibold14)
            .tracking(-0.28)
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .foregroundStyle(
                isDisabled
                ? Color.gray700
                : configuration.isPressed
                    ? Color.blue200 // 버튼 눌림
                    : Color.white) // 버튼 안 눌림
            .frame(width: 350, height: 50, alignment: .center)
            .background(
                isDisabled
                ? Color.gray200 // 비활성화 색
                : Color.darkblue500 // Default 색
            )
            .clipShape(RoundedRectangle(cornerRadius: 15))
    }
}


struct OkButton: View {
    var title: String
    var isDisabled: Bool = false
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
        }
        .buttonStyle(OkButtonStyle(isDisabled: isDisabled))
        .disabled(isDisabled)
    }
}

#Preview {
    OkButton(title: "확인", isDisabled: false) {
        print("확인")
    }
}
