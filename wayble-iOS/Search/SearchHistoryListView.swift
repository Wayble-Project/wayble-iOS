//
//  SearchHistoryListView.swift
//  wayble-iOS
//5
//  Created by 신민정 on 7/25/25.
//

//예전검색

import SwiftUI

struct SearchHistoryListView: View {
    let history: [SearchModel]
    var onSelect: (SearchModel) -> Void = { _ in }

    var body: some View {
        VStack(spacing: 0) {
            ForEach(history) { item in       // ← id: \.title 제거
                SearchRow(icon: item.icon, title: item.title, date: item.date)
                    .contentShape(Rectangle())
                    .onTapGesture { onSelect(item) }
                Divider()
            }
        }
    }
}
