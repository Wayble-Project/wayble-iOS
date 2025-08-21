//
////  wayble-iOS
////
////  Created by 햄무 on 7/11/25.
////
//
//import SwiftUI
//import Foundation
//import Observation
//
//@Observable
//class WaybleZoneNavigationRouter {
//    var path = NavigationPath()  // 네비게이션 경로를 저장하는 변수, 스택처럼 쌓임
//
//    /// 특정 화면을 추가 (Push 기능)
//    func push(_ route: WaybleZoneRoute) {
//        path.append(route)
//    }
//
//    /// 마지막 화면 제거 (Pop 기능)
//    func pop() {
//        if !path.isEmpty {
//            path.removeLast()
//        }
//    }
//
//    /// 네비게이션 초기화 (전체 Pop)
//    func reset() {
//        path = NavigationPath()
//    }
//}
//
//
////아래에 네비게이션 하고싶은 페이지 추가하기!
//enum WaybleZoneRoute: Hashable {
//    
//    case wZMain
//    case wZSearch
//    case wZplaceDetailView(id: Int)
//    case wZwritingReview(PlaceIdent)
//
//}
