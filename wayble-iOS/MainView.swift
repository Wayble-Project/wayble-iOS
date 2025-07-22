//
//  MainView.swift
//  wayble_iOS
//
//  Created by 신민정 on 7/9/25.
//

import SwiftUI


struct MainView: View {
    @State private var selectedIndex = 0
    @State private var router = NavigationRouter()
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack(alignment: .bottom) {
                Group {
                    switch selectedIndex {
                    case 0:
                        HomeView()
                    case 1:
                        MapView()
                    case 2:
                        ProfileView()
                    default:
                        Text("탭 오류")
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGray6))
                .ignoresSafeArea()

                CustomTabBarView(selectedIndex: $selectedIndex)
            }
        }
        .environment(router)
    }
}

#Preview {
    MainView()
}
