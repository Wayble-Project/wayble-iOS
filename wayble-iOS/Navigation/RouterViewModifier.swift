
//  wayble-iOS
//
//  Created by 햄무 on 7/12/25.
//

import Foundation
import SwiftUI

struct RouterViewModifier: ViewModifier {
    @Binding var selectedIndex: Int
    @State private var router = NavigationRouter()
    @Bindable var signupViewModel: SignupViewModel
    @Bindable var onboardingViewModel: OnboardingViewModel
    @Bindable var homeViewModel: HomeViewModel
    
    @State private var searchViewModel = SearchViewModel()
    @State private var place: PlaceModel = PlaceModel()
    
    
    
    private func routeView(for route: Route) -> some View {
        switch route {
        case .home:
            return AnyView(HomeView(selectedIndex: $selectedIndex, viewModel: onboardingViewModel, homeViewModel: homeViewModel)
                .navigationBarBackButtonHidden(true))
            
            
        case .signupEmail:
            return AnyView(SignupEmailView(viewModel: signupViewModel, selectedIndex: $selectedIndex)
                .navigationBarBackButtonHidden(true))
            
        case .findPassword:
            return AnyView(findPasswordView()
                .navigationBarBackButtonHidden(true))
            
        case .login:
            return AnyView(LoginView(selectedIndex: $selectedIndex, onboardingViewModel: onboardingViewModel, homeViewModel: homeViewModel))
            
        case .wayblezone:
            return AnyView(WaybleZoneMainView(vm: TopPlaceViewModel())
                .navigationBarBackButtonHidden(true))
            
        case .onboardingCompleted:
            return AnyView(OnboardingCompletedView(viewModel: onboardingViewModel, homeViewModel: homeViewModel, selectedIndex: $selectedIndex)
                .navigationBarBackButtonHidden(true))
            
        case .routeDetail:
            return AnyView(RouteDetail()
                .navigationBarBackButtonHidden(true))
            
        case .searchHome:
            return AnyView(SearchHomeView(selectedIndex: $selectedIndex)
                .navigationBarBackButtonHidden(true))
            
        case .splashView:
            return AnyView(SplashView(selectedIndex: $selectedIndex, onboardingViewModel: onboardingViewModel, homeViewModel: homeViewModel)
                .navigationBarBackButtonHidden(true))
            
        case .signupCompleted:
            return AnyView(SignupCompletedView(viewModel: signupViewModel, selectedIndex: $selectedIndex)
                .navigationBarBackButtonHidden(true))
            
        case .onboardingRoot:
            return AnyView(OnboardingRootView(viewModel: onboardingViewModel, selectedIndex: $selectedIndex)
                .navigationBarBackButtonHidden(true))
            
        case .signupTerm:
            return AnyView(SignupTermsView(selectedIndex: $selectedIndex)
                .navigationBarBackButtonHidden(true))
            
//        case .waybleZoneSearch:
//            return AnyView(WaybleZoneSearchView()
//                .navigationBarBackButtonHidden(true))
            
        //TODO: - 여기 에러 나서 잡긴 했는데 흠.. 제대로 수정된 건진 모르겠습니다...
        
        /*case .placeDetailView(let zone): // let zone 넣고
            return  AnyView(PlaceDetailView(zone: zone) //여기에 zone 넣었어요..
                .navigationBarBackButtonHidden(true))
         */
            /// NavigationRouter 에 case placeDetailView 를 case placeDetailView(let zone)으로 넣음
            /// 그리고 RouterViewModifier 에 있는 case .placeDetailView(안에 let zone) 넣고 파라미터로 zone: zone 넣음
            
            
//        case .writeReview:
//            return AnyView(WriteReView(viewModel: FacilitySelectionViewModel())
//                .navigationBarBackButtonHidden(true))
            
        case let .searchBar(entryType):
            return AnyView(
                SearchBarView(
                    viewModel: searchViewModel,
                    place: $place,
                    selectedIndex: $selectedIndex,
                    entryPoint: .directions,
                    entryType: entryType
                )
                .navigationBarBackButtonHidden(true)
            )
            /*
             case .searchBar:
             return AnyView(SearchBarView(selectedIndex: $selectedIndex, entryPoint: .directions)
             .navigationBarBackButtonHidden(true))
             */
            
        case .OnlyMapView:
            return AnyView(
                SearchBarView(
                    viewModel: searchViewModel, place: $place,
                    selectedIndex: $selectedIndex,
                    entryPoint: .directions
                )
                .navigationBarBackButtonHidden(true)
            )
            /*
             case .OnlyMapView:
             return AnyView(SearchBarView(selectedIndex: $selectedIndex, entryPoint: .directions)
             .navigationBarBackButtonHidden(true))
             */
            
        case .mapDetail:
            return AnyView(
                MapDetailView(
                    place: place,
                    selectedIndex: $selectedIndex,
                    searchBarViewID: .constant(UUID()),
                    selectedDeparture: .constant(nil),
                    selectedArrival: .constant(nil)
                )
                .navigationBarBackButtonHidden(true)
            )

        case .transportation(let entryType, let arrivalPlace, let departurePlace):
            return AnyView(
                Transportation(
                    selectedIndex: $selectedIndex,
                    entryType: entryType,
                    selectedArrival: .constant(arrivalPlace),
                    selectedDeparture: .constant(departurePlace),
                    viewModel: TransportationViewModel(),
                    searchViewModel: $searchViewModel,
                    transportation: searchViewModel.transportation
                )
                .navigationBarBackButtonHidden(true)
            )
            
        case .mainMapView:
            return AnyView(MainMapView()
                .navigationBarBackButtonHidden(true))
            
        }
    }
    
    
    func body(content: Content) -> some View {
        NavigationStack(path: $router.path) {
            content
                .environment(router)
                .navigationDestination(for: Route.self) { route in
                    routeView(for: route)
                }
        }
    }
}

extension View {
    func withRouter(
        selectedIndex: Binding<Int>,
        router: NavigationRouter = NavigationRouter(),
        signupViewModel: SignupViewModel = SignupViewModel(),
        onboardingViewModel: OnboardingViewModel = OnboardingViewModel(),
        homeViewModel: HomeViewModel = HomeViewModel()
    ) -> some View {
        self
            .modifier(RouterViewModifier(
                selectedIndex: selectedIndex,
                signupViewModel: signupViewModel,
                onboardingViewModel: onboardingViewModel, homeViewModel: homeViewModel
            ))
            .environment(router)
            .navigationDestination(for: Route.self) { route in
                RouterViewModifier(
                    selectedIndex: selectedIndex,
                    signupViewModel: signupViewModel,
                    onboardingViewModel: onboardingViewModel, homeViewModel: homeViewModel
                ).destination(for: route)
            }
    }
}


extension RouterViewModifier {
    @ViewBuilder
    func destination(for route: Route) -> some View {
        routeView(for: route)
    }
}

//dummy
struct WaybleZoneView: View {
    var body: some View { Text("WaybleZone") }
}
