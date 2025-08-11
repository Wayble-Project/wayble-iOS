//
//  MainMapView.swift
//  wayble-iOS
//
//  Created by 이서현 on 8/11/25.
//

import SwiftUI

struct MainMapView: View {
    
    @Environment(NavigationRouter.self) private var router
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                SearchBar()
                Spacer()
                HeartButton()
            } //h
            .padding(.bottom, 14)
            TopConvenientBar()
                .padding(.bottom, 21)
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    MainMapView()
    
}
