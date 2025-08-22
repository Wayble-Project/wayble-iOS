//
//  VerifyField.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/28/25.
//

import SwiftUI



//FIXME: - isCheckingMismatch 타입 변경?
//FIXME: - 재요청 -> 타이머 발동

struct VerifyField: View {
    @Binding var inputCode: String            // 외부에서 상태 바인딩
    @FocusState private var isFocused: Bool  // 포커스 상태
    var storedCode: String             // 인증코드
    var isCheckingMismatch: Bool          // 확인 버튼 눌렸는지 여부

    
    @Binding var showPopup: Bool
    
    private var fieldState: FieldState {
        if isCheckingMismatch && inputCode != storedCode {
            return .mismatched
        } else if isFocused {
            return .focused
        } else if !inputCode.isEmpty {
            return .completed
        } else {
            return .default
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("인증코드")
                .font(.mainTextSemibold14)
                .foregroundStyle(Color("gray-900"))
                .tracking(-0.28)
                .padding(.bottom, 5)
            
            HStack(spacing: 0) {
                TextField("인증코드를 입력해주세요", text: $inputCode)
                    .font(.mainTextRegular14)
                    .tracking(-0.28)
                    .foregroundStyle(Color("gray-900"))
                    .autocorrectionDisabled(true)
                    .keyboardType(.numberPad)
                
                Text("00:50")
                    .font(.mainTextSemibold14)
                    .foregroundStyle(Color("gray-700"))
                    .padding(.trailing, 11)
                
                Button(action: {
                    showPopup = true
                }) {
                    Text("재요청")
                        .font(.mainTextSemibold14)
                        .foregroundStyle(Color("gray-700"))
                        .padding(7)
                        .background(
                            Color("gray-200")
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            )
                }

            }//h
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .frame(width: 350, height: 50)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(borderColor(for: fieldState), lineWidth: 1)
            )
            .focused($isFocused)
            
            
            Text("인증코드가 올바르지 않습니다.")
                .font(.mainTextRegular12)
                .foregroundStyle(fieldState == .mismatched ? Color.error : Color.white) //틀렸을 때만 보이게
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
            return Color.error
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
        inputCode.count >= 8
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
        storedPassword: "12345678",
        isCheckingMismatch: true
    )
}

*/





/*
#Preview {
    VerifyField()
}
*/
