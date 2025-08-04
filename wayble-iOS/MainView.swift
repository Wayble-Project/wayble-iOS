//
//  MainView.swift
//  wayble_iOS
//
//  Created by 신민정 on 7/9/25.
//

import SwiftUI

struct MainView: View {
    @State private var place = PlaceModel()
    @State private var searchBarViewID = UUID()
    //@State private var selectedIndex = 11
    @Binding var selectedIndex: Int
    @Binding var step: Int
    @State private var router = NavigationRouter()

    @State var signupViewModel = SignupViewModel()
    @State var onboardingViewModel = OnboardingViewModel()

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
                    case 4: WaybleZoneMainView(vm: TopPlaceViewModel())
                    case 5:
                        SearchBarView(selectedIndex: $selectedIndex, entryPoint: .directions)
                            .id(searchBarViewID)
                    case 6:
                        OnlyMapView(
                            place: $place,
                            selectedIndex: $selectedIndex,
                            searchBarViewID: $searchBarViewID
                        )
                    case 7: LoginView(selectedIndex: $selectedIndex)
                    case 8: SignupEmailView(viewModel: signupViewModel, selectedIndex: $selectedIndex) //동일한 뷰모델 -> 유저 정보 저장
                    case 9: SignupPasswordView(viewModel: signupViewModel, selectedIndex: $selectedIndex)
                    case 10: SignupCompletedView(viewModel: signupViewModel, selectedIndex: $selectedIndex)
                    case 11: SplashView(selectedIndex: $selectedIndex)
                    case 12: OnboardingCompletedView(viewModel: onboardingViewModel, selectedIndex: $selectedIndex)
                    case 13: OnboardingRootView(viewModel: onboardingViewModel, selectedIndex: $selectedIndex)
                    case 14: SignupTermsView(selectedIndex: $selectedIndex)
                       
                    default:
                        Text("오류!")
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
                    case .signupEmail:
                        SignupEmailView(viewModel: signupViewModel, selectedIndex: $selectedIndex)
                            .navigationBarBackButtonHidden(true)
                    case .findPassword:
                        findPasswordView()
                            .navigationBarBackButtonHidden(true)
                    case .login:
                        LoginView(selectedIndex: $selectedIndex)
                            .navigationBarBackButtonHidden(true)
                    case .wayblezone:
                        WaybleZoneMainView(vm: TopPlaceViewModel())
                            .navigationBarBackButtonHidden(true)
                    case .waybleZoneSearch:
                        WaybleZoneSearchView()
                            .navigationBarBackButtonHidden(true)
                    case .placeDetailView:
                        PlaceDetailView()
                            .navigationBarBackButtonHidden(true)
                    case .writeReview:
                        WriteReView(viewModel: FacilitySelectionViewModel())
                            .navigationBarBackButtonHidden(true)
                    case .signupCompleted:
                        SignupCompletedView(viewModel: signupViewModel, selectedIndex: $selectedIndex)
                            .navigationBarBackButtonHidden(true)
                    case .routeDetail:
                        RouteDetail()
                            .navigationBarBackButtonHidden(true)
                    case .searchBar:
                        SearchBarView(selectedIndex: $selectedIndex, entryPoint: .directions)
                            .navigationBarBackButtonHidden(true)
                    case .OnlyMapView:
                        SearchHomeView(selectedIndex: $selectedIndex)
                            .navigationBarBackButtonHidden(true)
                        
                    case .mapDetail(place: let place):
                        MapDetailView(
                            place: place,
                            selectedIndex: $selectedIndex,
                            searchBarViewID: $searchBarViewID
                        )
                        .navigationBarBackButtonHidden(true)
                    case .splashView:
                        SplashView(selectedIndex: $selectedIndex)
                            .navigationBarBackButtonHidden(true)
                    case .onboardingCompleted:
                        OnboardingCompletedView(viewModel: onboardingViewModel, selectedIndex: $selectedIndex)
                            .navigationBarBackButtonHidden(true)
                    case .onboardingRoot:
                        OnboardingRootView(viewModel: onboardingViewModel, selectedIndex: $selectedIndex)
                            .navigationBarBackButtonHidden(true)
                    case .signupTerm:
                        SignupTermsView(selectedIndex: $selectedIndex)
                            .navigationBarBackButtonHidden(true)
                    }
                }
            }
            
            if !shouldHideTabBar {
                CustomTabBarView(selectedIndex: $selectedIndex)
            }
        }
        .environment(router)
    }
    // 커스텀 바 안보이게 설정 !!
    // 안 보이고 싶은곳 selectedIndex 따라서 추가하기
    var shouldHideTabBar: Bool {
        switch selectedIndex {
        case 5,6,7,8,9,10,11,12,13,14:
            return true
        default:
            return false
        }
    }}

#Preview {
    MainView(selectedIndex: .constant(0), step: .constant(0))
}
