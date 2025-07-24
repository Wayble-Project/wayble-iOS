//
//  SuggestionRow.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/25/25.
//

// 자동완성

// SuggestionRow.swift

import SwiftUI

struct SuggestionRow: View {
    let keyword: String

    var body: some View {
        HStack(spacing: 11) {
            Image("search")
                .foregroundStyle(.black)
                .frame(width: 24, height: 24)
            Text(keyword)
                .font(.mainTextRegular16)
                .foregroundStyle(.black)
            Spacer()
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 20)
    }
}
