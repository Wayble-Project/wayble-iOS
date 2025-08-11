//
//  NoSearchView.swift
//  wayble-iOS
//
//  Created by 신민정 on 8/11/25.
//

import SwiftUI

struct NoSearchView: View {
    var body: some View {
        Text("길찾기 결과가 없습니다.")
            .font(.mainTextSemibold14)
            .foregroundStyle(Color.gray96)
            .multilineTextAlignment(.center)
    }
}



#Preview {
    NoSearchView()
}
