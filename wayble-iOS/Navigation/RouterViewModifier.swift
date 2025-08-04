
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
    
    @State private var searchViewModel = SearchViewModel()
    @State private var place: PlaceModel = PlaceModel()
    
    
    private func routeView(for route: Route) -> some View {
        switch route {
        case .home:
            return AnyView(HomeView(selectedIndex: $selectedIndex)
                .navigationBarBackButtonHidden(true))
            
            
        case .signupEmail:
            return AnyView(SignupEmailView(viewModel: signupViewModel, selectedIndex: $selectedIndex)
                .navigationBarBackButtonHidden(true))
            
        case .findPassword:
            return AnyView(findPasswordView()
                .navigationBarBackButtonHidden(true))
            
        case .login:
            return AnyView(LoginView(selectedIndex: $selectedIndex))
            
        case .wayblezone:
            return AnyView(WaybleZoneMainView()
                .navigationBarBackButtonHidden(true))
            
        case .onboardingCompleted:
            return AnyView(OnboardingCompletedView(viewModel: onboardingViewModel, selectedIndex: $selectedIndex)
                .navigationBarBackButtonHidden(true))
            
        case .routeDetail:
            return AnyView(RouteDetail()
                .navigationBarBackButtonHidden(true))
            
        case .searchHome:
            return AnyView(SearchHomeView(selectedIndex: $selectedIndex)
                .navigationBarBackButtonHidden(true))
            
        case .splashView:
            return AnyView(SplashView(selectedIndex: $selectedIndex)
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
            /*
             case .mapDetail(let place):
             return AnyView(MapDetailView(place: place, selectedIndex: $selectedIndex,searchBarViewID: .constant(UUID()))
             .navigationBarBackButtonHidden(true))
             
             */
            
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
        onboardingViewModel: OnboardingViewModel = OnboardingViewModel()
    ) -> some View {
        self
            .modifier(RouterViewModifier(
                selectedIndex: selectedIndex,
                signupViewModel: signupViewModel,
                onboardingViewModel: onboardingViewModel
            ))
            .environment(router)
            .navigationDestination(for: Route.self) { route in
                RouterViewModifier(
                    selectedIndex: selectedIndex,
                    signupViewModel: signupViewModel,
                    onboardingViewModel: onboardingViewModel
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



