//
//  SetPasswordField.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/15/25.
//

import SwiftUI

/*
enum PasswordFieldState {
    case `default`
    case focused
    case completed
    case mismatched
}
 */


//FIXME: - isCheckingMismatch 타입 변경
//FIXME: - 비밀번호 일치 (불일치해도 형식이 Valid 하면 통과됨 -> 로직 수정

struct SetPasswordField: View {
    @Binding var password: String            // 외부에서 상태 바인딩
    @Binding var confirmPassword: String
    @Binding var isMatched: Bool
    @FocusState private var isFocused: Bool  // 포커스 상태
    var setPassword: String             // 설정한 패스워드
    @State private var showPassword: Bool = true // 패스워드 공개 버튼

    var content: String
    var shouldCheckMatch: Bool = true
    
    private var fieldState: FieldState {
        if isFocused {
            return .focused
        } else if !isPasswordValid() {
            return .mismatched
        } else if shouldCheckMatch && !isPasswordMatched {
            return .mismatched
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
                .foregroundStyle(Color.gray900)
                .tracking(-0.28)
                .padding(.bottom, 5)
            
            HStack(spacing: 0) {
                if !showPassword {
                    SecureField("8자 이상의 비밀번호", text: $password)
                        .font(.mainTextRegular14)
                        .tracking(-0.28)
                        .foregroundStyle(Color.gray900)
                        .textContentType(.newPassword)
                        .focused($isFocused)
                } else {
                    TextField("8자 이상의 비밀번호", text: $password)
                        .font(.mainTextRegular14)
                        .tracking(-0.28)
                        .foregroundStyle(Color.gray900)
                        .textContentType(.newPassword)
                        .focused($isFocused)
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
            .frame(width: 350, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(borderColor(for: fieldState), lineWidth: 1)
            )
            .onChange(of: password) {
                isMatched = isPasswordMatched
            }
            .onChange(of: confirmPassword) {
                isMatched = isPasswordMatched
            }
            
            if(isPasswordValid()) {
                Text(content)
                    .font(.mainTextRegular12)
                    .foregroundStyle(Color.positive) // 조건에 부합할 때만 positive 색으로
                    .tracking(-0.24)
                    .padding(.leading, 5)
                    .padding(.top, 5)
            } else {
                Text(content)
                    .font(.mainTextRegular12)
                    .foregroundStyle(Color.gray500) // 조건에 부합할 때만 positive 색으로
                    .tracking(-0.24)
                    .padding(.leading, 5)
                    .padding(.top, 5)
                
            }
            
            
        }//v
    }
    
    

    private func borderColor(for state: FieldState) -> Color {
        switch state {
        case .focused:
            return Color(red: 1/255, green: 32/255, blue: 50/255)
            // #012032
        case .completed, .default, .mismatched:
            return Color.gray200
        }
    }

    // TODO: - 와프 요청해야 함!!
    private func textColor(for state: FieldState) -> Color {
        switch state {
        case .default:
            return Color(red: 150/255, green: 150/255, blue: 150/255) // #969696
        case .focused, .mismatched:
            return Color.gray900
        case .completed:
            return Color.darkblue500
        }
    }
    
    //MARK: - 비밀번호 8자 이상 , 저장 기능
    private func checkPasswordLength() -> Bool {
        password.count >= 8
    }
    
    private func savePassword() {
        // UserInfo 모델 만들기 -> 저장?
    }
    
    
    //MARK: - 대소문자, 특수기호 포함
    private func isPasswordValid() -> Bool {
        let upperCase = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*")
        let lowerCase = NSPredicate(format: "SELF MATCHES %@", ".*[a-z]+.*")
        let specialChar = NSPredicate(format: "SELF MATCHES %@", ".*[^A-Za-z0-9].*")
        
        return upperCase.evaluate(with: password) &&
                lowerCase.evaluate(with: password) &&
                specialChar.evaluate(with: password)
    }
    
    //MARK: - 패스워드 일치 여부
    private var isPasswordMatched: Bool { // 계산 속성
        return password == confirmPassword
    }
    
}




/*
#Preview {
    @Previewable
    @State var dummyPassword = "wayble1234" //아직 @state 변수 없어서 설정
    
    PasswordField(
        password: $dummyPassword,
        storedPassword: "12345678",
        isCheckingMismatch: true
    )
}

*/
