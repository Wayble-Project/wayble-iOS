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
    let router = NavigationRouter()
    @State private var selectedIndex = 0
    @State var userInfo = UserInfo()
    

    var body: some Scene {
        WindowGroup {
        //    WalkingView()
            MainView(selectedIndex: $selectedIndex)
                .withRouter(selectedIndex: $selectedIndex, router: router)
                .environment(router)
        }
    }
}
