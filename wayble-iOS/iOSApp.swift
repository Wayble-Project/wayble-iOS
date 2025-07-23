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
    @State private var selectedIndex = 0
    @State var userInfo = UserInfo()

    var body: some Scene {
        WindowGroup {
            MainView()
                .withRouter(selectedIndex: $selectedIndex)
        }
    }
}
