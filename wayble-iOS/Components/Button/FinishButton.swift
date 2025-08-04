//
//  FinishButton.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/10/25.
//

import SwiftUI

struct FinishButton: View {
    var onTap: () -> Void

    var body: some View {
        Button(action: {
            onTap()
        }) {
            HStack(alignment: .center) {
                Text("도착")
                    .font(.mainTextSemibold16)
                    .foregroundStyle(Color.white)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .frame(width: 110, height: 44)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.blue500)
            )
            .buttonStyle(.plain)
        }
    }
}

#Preview {
    FinishButton {
        // 예시 호출
        let lat = 37.5665
        let lng = 126.9780
        SearchViewModel().handleCenterChanged(lat: lat, lng: lng)
    }
}
