//
//  SearchHistoryListView.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/25/25.
//

//예전검색

import SwiftUI

struct SearchHistoryListView: View {
    let history: [SearchModel]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(history, id: \.title) { item in
                SearchRow(icon: item.icon, title: item.title, date: item.date)
                Divider()
            }
        }
    }
}


