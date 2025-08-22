//
//  longView.swift
//  wayble-iOS
//
//  Created by 신민정 on 8/2/25.
//

import SwiftUI

struct longView: View {
    var body: some View {
        VStack {
            Spacer()
            Text("도보 길안내는\n직선 거리 30km 이상일 경우\n제공되지 않습니다.")
                .font(.mainTextSemibold14)
                .foregroundStyle(Color("gray-96"))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.ignoresSafeArea())
    }
}

#Preview {
    longView()
}
