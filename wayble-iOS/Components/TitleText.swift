//
//  TitleText.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/13/25.
//

import SwiftUI

struct TitleText: View {
    var text: String
    var alignment: TextAlignment = .leading

        var body: some View {
            Text(text)
                .font(.mainTextSemibold24) // weight 600 = SemiBold
                .foregroundColor(.black)
                .lineSpacing(12) // 150% = 24 * 1.5 = 36 → lineHeight 계산시 간격으로는 12 라네요
                .tracking(-0.48)
                .multilineTextAlignment(alignment)
        }
}

#Preview {
    TitleText(text: "wayble 이용 약관에\n동의해 주세요")
}
