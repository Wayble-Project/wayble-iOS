//
//  SplashView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/14/25.
//

import SwiftUI

struct SplashView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var selectedIndex: Int
    @State private var showContent = false
    @State var onboardingViewModel = OnboardingViewModel()
    
    @State var step = 0

    var body: some View {
        if showContent {
            switch authViewModel.state {
            case .unknown:
                EmptyView()
            case .loggedIn:
                HomeView(selectedIndex: $selectedIndex)
            case .loggedOut:
                LoginView(selectedIndex: $selectedIndex)
            case .needsOnboarding:
                OnboardingRootView(viewModel: onboardingViewModel, selectedIndex: $selectedIndex)
            }
        } else {
            VStack {
                Image(.waybleLogo4)
                    .resizable()
                    .frame(width: 145, height: 95)
                    .padding(.bottom, 9.19)
                Text("Wayble")
                    .font(.mainTextBold30)
                ProgressView().padding(.top, 20)
            }
            .background(.white)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    showContent = true
                }
            }
        }
    }
}


#Preview {
    SplashView(selectedIndex: .constant(0))
}

// 동적으로 해야 하나?
