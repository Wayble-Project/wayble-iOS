////import SwiftUI
////
////struct WaybleZoneRouterViewModifier: View {
////    @State private var router = WaybleZoneRouter()
////
////    var body: some View {
////        NavigationStack(path: $router.path) {
////            WaybleZoneMainView(vm: TopPlaceViewModel())
////                .environment(router)
////                .navigationDestination(for: WaybleZoneRoute.self) { route in
////                    switch route {
////                    case .wayblezone:
////                        WaybleZoneMainView(vm: TopPlaceViewModel())
////                            .environment(router)
////                    case .waybleZoneSearch:
////                        WaybleZoneSearchView()
////                            .environment(router)
//////                    case .placeDetailView:
//////                        PlaceDetailView(vm: PlaceDetailViewModel(zone: zone))
////                    case .writeReview:
////                        WriteReView(viewModel: FacilitySelectionViewModel())
////                            .environment(router)
////                    }
////                }
////        }
////    }
////}
//
////실제 네비에 추가할 코드
////case .wayblezone:
////    AnyView(WaybleZoneFlowContainer()
////        .navigationBarBackButtonHidden(true))
//
////struct WaybleZoneRouterModifier: ViewModifier {
////    @State private var router = WaybleZoneRouter()
////    
////    func body(content: Content) -> some View {
////        NavigationStack(path: $router.path) {
////            content
////                .environment(router)
////                .navigationDestination(for: WaybleZoneRoute.self) { route in
////                    switch route {
////                    case .wayblezone:
////                        WaybleZoneMainView(vm: TopPlaceViewModel())
////                    case .waybleZoneSearch:
////                        WaybleZoneSearchView()
//////                    case .placeDetailView:
//////                        PlaceDetailView(vm: PlaceDetailViewModel(zone: zone))
////                    case .writeReview:
////                        WriteReView(viewModel: FacilitySelectionViewModel())
////                    }
////                }
////        }
////    }
////}
////
////extension View {
////    func withWaybleZoneRouter() -> some View {
////        modifier(WaybleZoneRouterModifier())
////    }
////}
//
//
//
//
////  wayble-iOS
////
////  Created by 햄무 on 7/12/25.
////
//
//import Foundation
//import SwiftUI
//
////struct WaybleZoneRouterViewModifier: ViewModifier {
////    @State private var wZrouter = WaybleZoneNavigationRouter()
////
////    private func routeView(for route: WaybleZoneRoute) -> some View {
////        Group {
////            switch route {
////            case .wZMain:
////                WaybleZoneMainView(vm: TopPlaceViewModel())
////
////            case .wZSearch:
////                WaybleZoneSearchView()
////       
////            case .wZplaceDetailView:
////               PlaceDetailView(vm: PlaceDetailViewModel())
////
////            case .wZwritingReview(let place):
////                WriteReView(viewModel: FacilitySelectionViewModel(),
////                            place: place )
////   
////            @unknown default:
////                    EmptyView()
////            }
////        }
////        .environment(wZrouter)
////    }
////
////    func body(content: Content) -> some View {
////        NavigationStack(path: $wZrouter.path) {
////            content
////                .environment(wZrouter)
////                .navigationDestination(for: WaybleZoneRoute.self) { route in
////                    routeView(for: route)
////                }
////        }
////    }
////}
//
//
//
////
////struct WaybleZoneRouterViewModifier: ViewModifier {
////    @State private var wzRouter = WaybleZoneNavigationRouter()
////
////  
////    @ViewBuilder
////    private func routeView(for route: WaybleZoneRoute) -> some View {
////        switch route {
////        case .wZMain:
////            WaybleZoneMainView(vm: TopPlaceViewModel())
////
////        case .wZSearch:
////            WaybleZoneSearchView()
////
////        case .wZplaceDetailView(let id):
////                 PlaceDetailView(vm: PlaceDetailViewModel(zoneID: id))
////
////        case .wZwritingReview(let place):
////            WriteReView(
////                viewModel: FacilitySelectionViewModel(),
////                place: place
////            )
////        case .addListView:
////            AddListView()
////        }
////    }
////
////    func body(content: Content) -> some View {
////        NavigationStack(path: $wzRouter.path) {
////            content
////                .environment(wzRouter)                   // 루트에도 환경 주입
////                .navigationDestination(for: WaybleZoneRoute.self) { route in
////                    routeView(for: route)                // ✅ 빌더가 서로 다른 타입 합성
////                        .environment(wzRouter)           // 목적지에도 필요하면 주입
////                }
////        }
////    }
////}
////
////extension View {
////     func withWaybleZoneRouter() -> some View {
////        modifier(WaybleZoneRouterViewModifier())
////    }
////}
////
//
//
//
//struct WaybleZoneFlowContainer: View {
//    // ✅ @State 대신 @Environment를 사용해 앱 전역의 라우터를 가져옵니다.
//    @Environment(WaybleZoneNavigationRouter.self) private var wzRouter
//
//    var body: some View {
//        @Bindable var bindableRouter = wzRouter
//        // 이제 이 NavigationStack은 앱 전역의 wzRouter 인스턴스를 사용합니다.
//        NavigationStack(path: $bindableRouter.path) {
//            WaybleZoneMainView(vm: TopPlaceViewModel())
//                // 환경에 이미 wzRouter가 있으므로, 여기서 다시 주입할 필요는 없습니다.
//                // 하위 뷰들은 자동으로 동일한 환경을 물려받습니다.
//                .navigationDestination(for: WaybleZoneRoute.self) { route in
//                    switch route {
//                    case .wZMain:
//                        WaybleZoneMainView(vm: TopPlaceViewModel())
//                    case .wZSearch:
//                        WaybleZoneSearchView()
//                    case .wZplaceDetailView(let id):
//                        PlaceDetailView(vm: PlaceDetailViewModel(zoneID: id))
//                    case .wZwritingReview(let place):
//                        WriteReView(viewModel: FacilitySelectionViewModel(), place: place)
//                 
//                    }
//                }
//        }
//    }
//}
//
//
