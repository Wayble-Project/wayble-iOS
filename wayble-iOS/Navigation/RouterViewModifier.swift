
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
        Group {
            switch route {
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
            case .wayblezone:
                WaybleZoneMainView()
                    .navigationBarBackButtonHidden(true)
            case .onboardingCompleted:
                OnboardingCompletedView()
                    .navigationBarBackButtonHidden(true)
            case .routeDetail:
                RouteDetail()
                    .navigationBarBackButtonHidden(true)
            case .searchHome:
                SearchHomeView()
                    .navigationBarBackButtonHidden(true)
            }
        }
        .environment(router)
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





//dummy
struct WaybleZoneView: View {
    var body: some View { Text("WaybleZone") }
}
