//
//  iOSApp.swift
//  iOS
//
//  Created by 신민정 on 7/10/25.
//

import SwiftUI

@main
struct iOSApp: App {
    var body: some Scene {
        WindowGroup {
            MainView().withRouter()
        }
    }
}
