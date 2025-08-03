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
    @Environment(OnboardingViewModel.self) private var viewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            Image("check02")
                .resizable()
                .frame(width: 33, height: 33)
                .padding(.bottom, 50.4)
            TitleText(text: "wayble과 함께할\n준비가 되었어요!", alignment: .center)
            
            Spacer()
            
            OkButton(title: "확인", isDisabled: false) {
                Task {
                    let success = await viewModel.completeOnboarding()
                    if success {
                        router.push(.home)
                    } else {
                        print("온보딩 전송 실패: 홈 화면으로 이동 X")
                    }
                }
            }
            .padding(.bottom, 54)
        }
        .navigationBarBackButtonHidden(true)
    }
    
}

#Preview {
    OnboardingCompletedView()
        .environment(OnboardingViewModel())
        .withRouter(selectedIndex: .constant(0),router: NavigationRouter())
}
