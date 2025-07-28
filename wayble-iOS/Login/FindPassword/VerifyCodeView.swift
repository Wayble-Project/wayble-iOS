//
//  VerifyCodeView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/15/25.
//


//TODO: - 인증코드 컴포넌트 만들기 - 인증 로직
//TODO: - 팝업창 비율 조정


import SwiftUI

struct VerifyCodeView: View {
    @State var showPopup = false
    @State private var inputCode: String = ""

    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                BackButton()
                    .padding(.top, 30)
                    .padding(.bottom, 27)
                TitleText(text: "해당 이메일 주소로\n인증코드를 발송했어요")
                    .padding(.bottom, 48)
                VerifyField(inputCode: $inputCode, storedCode: "012345", isCheckingMismatch: false, showPopup: $showPopup)
                Spacer()
                OkButton(title: "확인", isDisabled: false) {
                    print("인증코드 전송")
                    //인증코드 동일한지 확인하는 로직
                }
                .padding(.bottom, 54)
                
            } //v
            
            if showPopup {
                Color.black.opacity(0.5)
                    .ignoresSafeArea()
                ResendCodeAlertPopup(showPopup: $showPopup)
                
            }
        }
    }
}


struct ResendCodeAlertPopup: View {
    @Binding var showPopup: Bool
    var body: some View {
        ZStack (alignment: .center) {
            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .frame(width: 299, height: 200)
            VStack(spacing: 0) {
                Image("waybleLogo3")
                    .resizable()
                    .frame(width: 35, height: 23)
                    //.padding(.bottom, 27) //frame, image 간격이 있음
                    .padding(.bottom, 21)
                Text("인증코드가 다시 발송되었습니다")
                    .font(.mainTextSemibold16)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color.black)
                    .frame(width: .infinity, alignment: .top)
                    .padding(.bottom, 17)
                Button(action: {
                        showPopup = false
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 13)
                            .fill(Color.blue500)
                            .frame(width: 259, height: 50)
                        Text("확인")
                            .font(.mainTextSemibold14)
                            .foregroundStyle(Color.white)
                    }
                }
                //.padding(.bottom, 20)
            }
            .padding(.horizontal, 20)
        }
    }
}





#Preview {
    VerifyCodeView(showPopup: true)
        .environment(NavigationRouter())
}

 /*

#Preview {
    @Previewable @State var truee = true
    ResendCodeAlertPopup(showPopup: $truee)
        .environment(NavigationRouter())
}
*/
