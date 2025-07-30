//
//  WalkingView.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/29/25.
//

import SwiftUI

struct WalkingView: View {
    var body: some View {
        ZStack {
            NaverMapViewWrapper(lat: SampleRoute.path.first!.lat,
                                lng: SampleRoute.path.first!.lng)
                .edgesIgnoringSafeArea(.all)

          
        }
    }
}
#Preview {
    WalkingView()
}
