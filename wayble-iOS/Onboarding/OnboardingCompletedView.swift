//
//  OnboardingCompletedView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/18/25.
//

import SwiftUI


//FIXME: - image 변경해야 함

struct OnboardingCompletedView: View {
    var body: some View {
        VStack {
            Spacer()
            
            Image("check02")
                .resizable()
                .frame(width: 33, height: 33)
                .padding(.bottom, 50.4)
            TitleText(text: "wayble과 함께할\n준비가 되었어요!", alignment: .center)
            
            Spacer()
            
            OkButton(title: "확인", isDisabled: true) {
                print("appstorge 저장하는 코드")
            }
            .padding(.bottom, 54)
        }
    }
}

#Preview {
    OnboardingCompletedView()
}
