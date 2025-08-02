//
//  CustomTextField.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/17/25.
//

import SwiftUI


//FIXME: - isCheckingMismatch 타입 변경
//FIXME: - 에러 메시지 띄우기

struct CustomTextField: View {
    var text: String
    var placeHolder: String
    @Binding var textValue: String
    var keyboardType: UIKeyboardType = .default
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(text)
                .font(.mainTextSemibold14)
                .foregroundStyle(Color.gray900)
                .tracking(-0.28)
                .frame(height: 20)
                .padding(.bottom, 5)
            TextField(placeHolder, text: $textValue)
                .foregroundStyle(Color.gray900)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(.none)
                .autocorrectionDisabled(true)
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .frame(width: 350, height: 50)
                .font(.mainTextRegular14)
                .tracking(-0.28)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray200)
                )
            Text("에러 메시지 띄우기?")
                .font(.mainTextRegular12)
                .foregroundStyle(Color.pink) //조건 따라 수정
                .tracking(-0.24)
                .padding(.leading, 5)
                .padding(.top, 5)
                .focused($isFocused)
        }
    }
}

#Preview {
    @State var dummyNickname = ""
    CustomTextField(
        text: "닉네임",
        placeHolder: "닉네임을 입력해주세요",
        textValue: $dummyNickname,
        keyboardType: .default
    )
}



/*
#Preview {
    CustomTextField()
}
*/
