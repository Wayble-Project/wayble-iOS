//
//  OnboardingCompletedView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/18/25.
//

import SwiftUI


//FIXME: - image 변경해야 함

struct OnboardingCompletedView: View {
    @Environment(NavigationRouter.self) private var router
    @Bindable var viewModel: OnboardingViewModel
    
    @Binding var selectedIndex: Int
    
    
    
    var body: some View {
        VStack {
            Spacer()
            
            GeometryReader { geo in
                MP4View(filename: "OnBoarding", fileExtension: "mp4", size: geo.size)
                    //.frame(width: 154, height: 230)
                    .clipped()
            }
            //.frame(height: 540)
            .frame(width: 154, height: 230)
            .padding(.bottom, 30)
            TitleText(text: "wayble과 함께할\n준비가 되었어요!", alignment: .center)
                
            
            Spacer()
            
            OkButton(title: "확인", isDisabled: false) {
                Task {
                    let info = viewModel.userInfo
                    print("""
                    🧾 userInfo:
                    - email: \(info.email)
                    - password: \(info.password)
                    - nickname: \(info.nickname)
                    - birth: \(info.birth)
                    - gender: \(info.gender)
                    - hasDisability: \(info.hasDisability)
                    - disabilityType: \(info.disabilityType)
                    - mobilityAid: \(info.mobilityAid)
                    - isWithCompanion: \(info.isWithCompanion)
                    - loginType: \(info.loginType)
                    """)
                    let success = await viewModel.completeOnboarding()
                    if success {
                        selectedIndex = 0
                    } else {
                        print("온보딩 전송 실패: 홈 화면으로 이동 X")
                    }
                }
            }
            .padding(.bottom, 54)
        }
        .navigationBarBackButtonHidden(true)
        .padding(.horizontal, 20)
    }
    
}



 #Preview {
    struct PreviewWrapper: View {
        @State var selectedIndex = 0
        @State var viewModel = OnboardingViewModel()

        var body: some View {
            OnboardingCompletedView(viewModel: viewModel, selectedIndex: $selectedIndex)
                .withRouter(selectedIndex: $selectedIndex)
        }
    }

    return PreviewWrapper()
 }
 
