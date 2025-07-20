
//  wayble-iOS
//
//  Created by 햄무 on 7/12/25.
//

import Foundation
import SwiftUI

struct RouterViewModifier: ViewModifier {
    @State private var router = NavigationRouter()

    private func routeView(for route: Route) -> some View {
        Group {
            switch route {
            case .home:
                HomeView()
                    .navigationBarBackButtonHidden(true)
            case .signup:
                SignupEmailView()
                    .navigationBarBackButtonHidden(true)
            case .findPassword:
                findPasswordView()
                    .navigationBarBackButtonHidden(true)
//            case .login:
//                LoginView()
            case .wayblezone:
                WaybleZoneView()
                    .navigationBarBackButtonHidden(true)
            case .onboardingCompleted:
                OnboardingCompletedView()
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
     func withRouter() -> some View {
        modifier(RouterViewModifier())
    }
}





//dummy
struct WaybleZoneView: View {
    var body: some View { Text("WaybleZone") }
}
