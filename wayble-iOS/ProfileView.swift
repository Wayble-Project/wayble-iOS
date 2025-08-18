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
            Spacer()
        }
    }
}





#Preview {
    ProfileView(selectedIndex: .constant(0))
}
