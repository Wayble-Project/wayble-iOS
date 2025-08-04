//
//  WalkViewModel.swift
//  wayble-iOS
//
//  Created by 신민정 on 8/2/25.
//

import SwiftUI
import Foundation

@Observable
class WalkViewModel {
    var routes: [RouteData] = [SampleRoutes.shortest, SampleRoutes.wayble]
    var selectedRoute: RouteData = SampleRoutes.wayble

    var mapRefreshTrigger = UUID()
    
    func selectRoute(_ route: RouteData) {
        selectedRoute = route
        mapRefreshTrigger = UUID()
    }
}
