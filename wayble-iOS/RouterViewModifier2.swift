//  wayble-iOS
//
//  Created by 햄무 on 7/12/25.
//

/*
import Foundation
import SwiftUI


struct RouterViewModifier2: ViewModifier {
    @State private var searchViewModel = SearchViewModel()
    @Binding var selectedIndex: Int
    @State private var router = NavigationRouter()
    @State private var place: PlaceModel = PlaceModel()
    
    private func routeView(for route: Route) -> some View {
        switch route {
        case .home:
            return AnyView(HomeView(selectedIndex: $selectedIndex)
                .navigationBarBackButtonHidden(true))

        case .signup:
            return AnyView(SignupEmailView()
                .navigationBarBackButtonHidden(true))

        case .findPassword:
            return AnyView(findPasswordView()
                .navigationBarBackButtonHidden(true))

        case .login:
            return AnyView(LoginView())

        case .wayblezone:
            return AnyView(WaybleZoneMainView()
                .navigationBarBackButtonHidden(true))

        case .onboardingCompleted:
            return AnyView(OnboardingCompletedView()
                .navigationBarBackButtonHidden(true))

        case .routeDetail:
            return AnyView(RouteDetail()
                .navigationBarBackButtonHidden(true))

        case .searchHome:
            return AnyView(SearchHomeView(selectedIndex: $selectedIndex)
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
        
        case .OnlyMapView:
            return AnyView(
                SearchBarView(
                    viewModel: searchViewModel, place: $place,
                    selectedIndex: $selectedIndex,
                    entryPoint: .directions
                )
                .navigationBarBackButtonHidden(true)
            )
            
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
    func withRouter(selectedIndex: Binding<Int>, router: NavigationRouter) -> some View {
        self
            .environment(router)
            .navigationDestination(for: Route.self) { route in
                RouterViewModifier(selectedIndex: selectedIndex).destination(for: route)
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
*/
