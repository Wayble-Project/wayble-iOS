//
//  StartButton.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/10/25.
//

import SwiftUI

struct StartButton: View {
    var body: some View {
        HStack(alignment: .center) {
            Text("출발")
                .font(.mainTextSemibold16)
                .foregroundStyle(Color.blue700)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 12)
        .frame(width: 110, height: 44, alignment: .center)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color(.blue500), lineWidth: 1)
        )
    }
}


