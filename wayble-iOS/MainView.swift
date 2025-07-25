//
//  MainView.swift
//  wayble_iOS
//
//  Created by 신민정 on 7/9/25.
//

import SwiftUI

struct MainView: View {
    @State private var searchBarViewID = UUID()
    @State private var selectedIndex = 0
    @State private var router = NavigationRouter()

    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack(path: $router.path) {
                ZStack {
                    switch selectedIndex {
                        // 밑에 추가하고 싶은 뷰 적기
                    case 0: HomeView(selectedIndex: $selectedIndex)
                    case 1: MapView()
                    case 2: ProfileView()
                    case 3: SearchHomeView(selectedIndex: $selectedIndex)
                    case 4: WaybleZoneMainView()
                    case 5:
                        SearchBarView(selectedIndex: $selectedIndex, entryPoint: .directions)
                            .id(searchBarViewID)
                    default: Text("오류!")
                    }
                }
                //모든 뷰에서 탭이 보이도록 설정
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .searchHome:
                        SearchHomeView(selectedIndex: $selectedIndex)
                            .navigationBarBackButtonHidden(true)
                    case .home:
                        HomeView(selectedIndex: $selectedIndex)
                            .navigationBarBackButtonHidden(true)
                    case .signup:
                        SignupEmailView()
                            .navigationBarBackButtonHidden(true)
                    case .findPassword:
                        findPasswordView()
                            .navigationBarBackButtonHidden(true)
                    case .login:
                        LoginView()
                            .navigationBarBackButtonHidden(true)
                    case .wayblezone:
                        WaybleZoneMainView()
                            .navigationBarBackButtonHidden(true)
                    case .onboardingCompleted:
                        OnboardingCompletedView()
                            .navigationBarBackButtonHidden(true)
                    case .routeDetail:
                        RouteDetail()
                            .navigationBarBackButtonHidden(true)
                    case .searchBar:
                        SearchBarView(selectedIndex: $selectedIndex, entryPoint: .directions)
                            .navigationBarBackButtonHidden(true)
                    case .mapDetail(place: let place):
                        MapDetailView(
                            place: place,
                            selectedIndex: $selectedIndex,
                            searchBarViewID: $searchBarViewID
                        )
                        .navigationBarBackButtonHidden(true)
                    }
                }
            }

            CustomTabBarView(selectedIndex: $selectedIndex)
        }
        .environment(router)
    }
}

#Preview {
    MainView()
}
