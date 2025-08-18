//
//  iOSApp.swift
//  iOS
//
//  Created by 신민정 on 7/10/25.
//

import SwiftUI
import Observation
import Foundation

@main
struct iOSApp: App {
    @State private var selectedIndex = 11 //13 온보딩 , 7 로그인뷰, 0 홈 , 11 스플래시 뷰
    @State private var step = 0
    @State var userInfo = UserInfo()
    @StateObject var authViewModel = AuthViewModel()
    @StateObject private var searchRoute = SearchRouteState()

    var body: some Scene {
        WindowGroup {
            MainView(selectedIndex: $selectedIndex, step: $step)
                .withRouter(selectedIndex: $selectedIndex)
                .environmentObject(authViewModel)
                .environment(userInfo)  /// 0811
                .environmentObject(searchRoute) ///0818
                .withWaybleZoneRouter()
                
        }
    }
}
