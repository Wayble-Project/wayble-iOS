//
//  CustomTextField.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/17/25.
//

import SwiftUI

enum ValidationState {
    case valid
    case tooShort(min: Int)
    case duplicated
    case invalidBirthFormat
    case invalidNicknameFormat
}

//FIXME: - isCheckingMismatch 타입 변경
//FIXME: - 에러 메시지 띄우기

struct CustomTextField: View {
    var text: String
    var placeHolder: String
    @Binding var textValue: String
    var keyboardType: UIKeyboardType = .default
    @Binding var validationState: ValidationState
    @FocusState private var isFocused: Bool

    private var errorMessage: String {
        switch validationState {
        case .tooShort(let min):
            return "닉네임은 \(min)자 이상이어야 합니다."
        case .duplicated:
            return "이미 사용 중인 닉네임입니다."
        case .invalidBirthFormat:
            return "올바른 생년월일 형식이 아닙니다."
        case .invalidNicknameFormat:
            return "닉네임은 한글 또는 영문만 사용할 수 있습니다."
        case .valid:
            return ""
        }
    }
    
    private var hasError: Bool {
        switch validationState {
        case .valid:
            return false
        default:
            return true
        }
    }
    

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
                .frame(maxHeight: .infinity)
                .frame(height: 50)
                .font(.mainTextRegular14)
                .tracking(-0.28)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(hasError ? Color.error : Color.gray200)
                )
            if hasError {
                Text(errorMessage)
                    .font(.mainTextRegular12)
                    .foregroundStyle(.error)
                    .tracking(-0.24)
                    .padding(.leading, 5)
                    .padding(.top, 5)
            }
        }
    }
}

