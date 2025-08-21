//
//  ProfileView.swift
//  wayble_iOS
//
//  Created by 신민정 on 7/9/25.
//

import SwiftUI


struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @Binding var selectedIndex: Int
    
    var body: some View {
        VStack {
            /*
            Button("로그아웃(키체인 삭제)") {
                KeychainManager.standard.deleteSession(for: "tokenInfoKey")
                authViewModel.state = .loggedOut
                selectedIndex = 7
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .shadow(radius: 3)
            .padding(.top, 100)
            */
            Image(.waybleLogo4)
                .resizable()
                .frame(width: 140, height: 90)
                .padding(.top,130)
            Spacer()
            
            OkButton(title: "로그아웃", isDisabled: false) {
                KeychainManager.standard.deleteSession(for: "tokenInfoKey")
                authViewModel.state = .loggedOut
                selectedIndex = 7
            }
            .padding(.bottom, 140)
        }
        .padding(.horizontal, 20)
    }
}





#Preview {
    ProfileView(selectedIndex: .constant(0))
}
