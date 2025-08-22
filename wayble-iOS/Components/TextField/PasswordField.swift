//
//  PasswordField.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/13/25.
//

import SwiftUI


//FIXME: - isCheckingMismatch 타입 변경

struct PasswordField: View {
    @Binding var password: String            // 외부에서 상태 바인딩
    @FocusState private var isFocused: Bool  // 포커스 상태
    @State private var showPassword: Bool = false // 패스워드 공개 버튼
    @Binding var isCheckingMismatch: Bool         // 확인 버튼 눌렸는지 여부

    private var fieldState: FieldState {
        if isCheckingMismatch {
            return .mismatched
        } else if isFocused {
            return .focused
        } else if !password.isEmpty {
            return .completed
        } else {
            return .default
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("비밀번호")
                .font(.mainTextSemibold14)
                .foregroundStyle(Color("gray-900"))
                .tracking(-0.28)
                .padding(.bottom, 5)
            
            HStack(spacing: 0) {
                if !showPassword {
                    SecureField("8자 이상의 비밀번호", text: $password)
                        .font(.mainTextRegular14)
                        .tracking(-0.28)
                        .foregroundStyle(Color("gray-900"))
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.none)
                } else {
                    TextField("8자 이상의 비밀번호", text: $password)
                        .font(.mainTextRegular14)
                        .tracking(-0.28)
                        .foregroundStyle(Color("gray-900"))
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.none)
                }
                
                Button(action: {
                    showPassword.toggle()
                }) {
                    Image("eyeClosed")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .opacity(showPassword ? 1.0 : 0.5)
                }

            }//h
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .frame(maxHeight: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(borderColor(for: fieldState), lineWidth: 1)
            )
            .focused($isFocused)
            
            
            Text("이메일 혹은 비밀번호가 틀립니다")
                .font(.mainTextRegular12)
                .foregroundStyle(fieldState == .mismatched ? Color("error") : Color.white) //틀렸을 때만 보이게
                .tracking(-0.24)
                .padding(.leading, 5)
                .padding(.top, 5)
            
             
        }//v
    }
    
    

    private func borderColor(for state: FieldState) -> Color {
        switch state {
        case .default:
            return Color("gray-200")
        case .focused:
            return Color(red: 1/255, green: 32/255, blue: 50/255)
            // #012032
        case .completed:
            return Color("gray-200")
        case .mismatched:
            return Color("error")
        }
    }

    private func textColor(for state: FieldState) -> Color {
        switch state {
        case .default:
            return Color(red: 150/255, green: 150/255, blue: 150/255) // #969696
        case .focused, .mismatched:
            return Color("gray-900")
        case .completed:
            return Color("darkblue-500")
        }
    }
    
    //MARK: - 비밀번호 8자 이상 , 저장 기능
    private func checkPasswordLength() -> Bool {
        password.count >= 8
    }
    
    private func savePassword() {
        // UserInfo 모델 만들기 -> 저장?
    }
}


/*
#Preview {
    @Previewable
    @State var dummyPassword = "wayble1234" //아직 @state 변수 없어서 설정
    
    PasswordField(
        password: $dummyPassword,
        isCheckingMismatch: true
    )
}

*/
