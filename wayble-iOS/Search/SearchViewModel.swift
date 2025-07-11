//
//  SearchViewModel.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/11/25.
//

import SwiftUI
import Observation



@Observable
class SearchViewModel {
    var searchText: String = ""
    var searchModels: [SearchModel] = [
        SearchModel(icon: "search", title: "음식점", date: "06.27"),
        SearchModel(icon: "location", title: "카페 아임히어", date: "06.11")
    ]
}
