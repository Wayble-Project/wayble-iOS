//import SwiftUI
//
//struct WaybleZoneRouterViewModifier: View {
//    @State private var router = WaybleZoneRouter()
//
//    var body: some View {
//        NavigationStack(path: $router.path) {
//            WaybleZoneMainView(vm: TopPlaceViewModel())
//                .environment(router)
//                .navigationDestination(for: WaybleZoneRoute.self) { route in
//                    switch route {
//                    case .wayblezone:
//                        WaybleZoneMainView(vm: TopPlaceViewModel())
//                            .environment(router)
//                    case .waybleZoneSearch:
//                        WaybleZoneSearchView()
//                            .environment(router)
////                    case .placeDetailView:
////                        PlaceDetailView(vm: PlaceDetailViewModel(zone: zone))
//                    case .writeReview:
//                        WriteReView(viewModel: FacilitySelectionViewModel())
//                            .environment(router)
//                    }
//                }
//        }
//    }
//}

//실제 네비에 추가할 코드
//case .wayblezone:
//    AnyView(WaybleZoneFlowContainer()
//        .navigationBarBackButtonHidden(true))

//struct WaybleZoneRouterModifier: ViewModifier {
//    @State private var router = WaybleZoneRouter()
//    
//    func body(content: Content) -> some View {
//        NavigationStack(path: $router.path) {
//            content
//                .environment(router)
//                .navigationDestination(for: WaybleZoneRoute.self) { route in
//                    switch route {
//                    case .wayblezone:
//                        WaybleZoneMainView(vm: TopPlaceViewModel())
//                    case .waybleZoneSearch:
//                        WaybleZoneSearchView()
////                    case .placeDetailView:
////                        PlaceDetailView(vm: PlaceDetailViewModel(zone: zone))
//                    case .writeReview:
//                        WriteReView(viewModel: FacilitySelectionViewModel())
//                    }
//                }
//        }
//    }
//}
//
//extension View {
//    func withWaybleZoneRouter() -> some View {
//        modifier(WaybleZoneRouterModifier())
//    }
//}




//  wayble-iOS
//
//  Created by 햄무 on 7/12/25.
//

import Foundation
import SwiftUI

//struct WaybleZoneRouterViewModifier: ViewModifier {
//    @State private var wZrouter = WaybleZoneNavigationRouter()
//
//    private func routeView(for route: WaybleZoneRoute) -> some View {
//        Group {
//            switch route {
//            case .wZMain:
//                WaybleZoneMainView(vm: TopPlaceViewModel())
//
//            case .wZSearch:
//                WaybleZoneSearchView()
//       
//            case .wZplaceDetailView:
//               PlaceDetailView(vm: PlaceDetailViewModel())
//
//            case .wZwritingReview(let place):
//                WriteReView(viewModel: FacilitySelectionViewModel(),
//                            place: place )
//   
//            @unknown default:
//                    EmptyView()
//            }
//        }
//        .environment(wZrouter)
//    }
//
//    func body(content: Content) -> some View {
//        NavigationStack(path: $wZrouter.path) {
//            content
//                .environment(wZrouter)
//                .navigationDestination(for: WaybleZoneRoute.self) { route in
//                    routeView(for: route)
//                }
//        }
//    }
//}

struct WaybleZoneRouterViewModifier: ViewModifier {
    @State private var wzRouter = WaybleZoneNavigationRouter()

  
    @ViewBuilder
    private func routeView(for route: WaybleZoneRoute) -> some View {
        switch route {
        case .wZMain:
            WaybleZoneMainView(vm: TopPlaceViewModel())

        case .wZSearch:
            WaybleZoneSearchView()

        case .wZplaceDetailView:
            PlaceDetailView(vm: PlaceDetailViewModel())

        case .wZwritingReview(let place):
            WriteReView(
                viewModel: FacilitySelectionViewModel(),
                place: place
            )
        }
    }

    func body(content: Content) -> some View {
        NavigationStack(path: $wzRouter.path) {
            content
                .environment(wzRouter)                   // 루트에도 환경 주입
                .navigationDestination(for: WaybleZoneRoute.self) { route in
                    routeView(for: route)                // ✅ 빌더가 서로 다른 타입 합성
                        .environment(wzRouter)           // 목적지에도 필요하면 주입
                }
        }
    }
}

extension View {
     func withWaybleZoneRouter() -> some View {
        modifier(WaybleZoneRouterViewModifier())
    }
}



