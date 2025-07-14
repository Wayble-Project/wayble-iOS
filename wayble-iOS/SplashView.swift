//
//  SplashView.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/14/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Image("waybleLogo4")
                .resizable()
                .frame(width: 145, height: 95)
                .padding(.bottom, 9.19)
            Text("Wayble")
                .font(.mainTextBold30)
        }
    }
}


#Preview {
    SplashView()
}

// 동적으로 해야 하나?
