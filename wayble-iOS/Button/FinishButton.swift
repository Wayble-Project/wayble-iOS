//
//  FinishButton.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/10/25.
//

import SwiftUI

struct FinishButton: View {
    var body: some View {
        Button(action : {}) {
            HStack(alignment: .center) {
                Text("도착")
                    .font(.mainTextSemibold16)
                    .foregroundStyle(Color.white)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .frame(width: 110, height: 44, alignment: .center)
            .clipShape(RoundedRectangle(cornerRadius: 24))
            .background(Color.blue500)
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    FinishButton()
}
