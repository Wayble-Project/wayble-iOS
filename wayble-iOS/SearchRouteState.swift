//
//  SearchRouteState.swift
//  wayble-iOS
//
//  Created by 이서현 on 8/18/25.
//

import SwiftUI

final class SearchRouteState: ObservableObject {
    enum EntryPoint { case home, directions }
    @Published var entryPoint: EntryPoint = .home
}
