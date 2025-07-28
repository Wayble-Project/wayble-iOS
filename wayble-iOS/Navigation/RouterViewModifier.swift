
//  wayble-iOS
//
//  Created by 햄무 on 7/12/25.
//

import Foundation
import SwiftUI

struct RouterViewModifier: ViewModifier {
    @Binding var selectedIndex: Int
    @State private var router = NavigationRouter()

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

        case .searchBar:
            return AnyView(SearchBarView(selectedIndex: $selectedIndex, entryPoint: .directions)
                .navigationBarBackButtonHidden(true))
        
        case .OnlyMapView:
            return AnyView(SearchBarView(selectedIndex: $selectedIndex, entryPoint: .directions)
                .navigationBarBackButtonHidden(true))
            
        case .mapDetail(let place):
                return AnyView(MapDetailView(place: place, selectedIndex: $selectedIndex,searchBarViewID: .constant(UUID()))
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
    func withRouter(selectedIndex: Binding<Int>) -> some View {
        modifier(RouterViewModifier(selectedIndex: selectedIndex))
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
