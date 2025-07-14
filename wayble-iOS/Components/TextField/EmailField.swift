//
//  EmailField.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/12/25.
//

import SwiftUI

enum EmailFieldState {
    case `default`
    case focused
    case completed
    case mismatched
}

//FIXME: - isCheckingMismatch 타입 변경

struct EmailField: View {
    @Binding var email: String            // 외부에서 상태 바인딩
    @FocusState private var isFocused: Bool  // 포커스 상태
    var storedEmail: String             // 저장된 이메일
    var isCheckingMismatch: Bool          // 확인 버튼 눌렸는지 여부

    private var fieldState: EmailFieldState {
        if isCheckingMismatch && email != storedEmail {
            return .mismatched
        } else if isFocused {
            return .focused
        } else if !email.isEmpty {
            return .completed
        } else {
            return .default
        }
    }

    var body: some View {
        VStack(alignment: .leading,spacing: 0) {
            Text("이메일(아이디)")
                .font(.mainTextSemibold14)
                .foregroundStyle(Color.gray900)
                .tracking(-0.28)
                .frame(height: 20)
                .padding(.bottom, 5)
            TextField("wayble@email.com", text: $email)
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .frame(width: 350, height: 50)
                .font(.mainTextRegular14)
                .tracking(-0.28)
                .foregroundStyle(Color.gray900)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(borderColor(for: fieldState), lineWidth: 1)
                )
                .focused($isFocused)
        }
    }
    

    private func borderColor(for state: EmailFieldState) -> Color {
        switch state {
        case .default:
            return Color.gray200
        case .focused:
            return Color(red: 1/255, green: 32/255, blue: 50/255)
            // #012032
        case .completed:
            return Color.gray200
        case .mismatched:
            return Color.error
        }
    }

    private func textColor(for state: EmailFieldState) -> Color {
        switch state {
        case .default:
            return Color(red: 150/255, green: 150/255, blue: 150/255) // #969696
        case .focused, .mismatched:
            return Color.gray900
        case .completed:
            return Color.darkblue500
        }
    }
}

#Preview {
    @Previewable 
    @State var dummyEmail = "abcd@naver.com" //아직 @state 변수 없어서 설정
    
    return EmailField(
        email: $dummyEmail,
        storedEmail: "abc@naver.com",
        isCheckingMismatch: true
    )
}
