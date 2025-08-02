//
//  WalkingView.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/29/25.
//

import SwiftUI

struct WalkingView: View {
    @Bindable var viewModel: WalkViewModel
    var body: some View {
        
        ZStack(alignment: .bottom) {
            NaverMapViewWrapper(route: viewModel.selectedRoute)
                .id(viewModel.mapRefreshTrigger)
                .edgesIgnoringSafeArea(.all)
                

            VStack {
                Spacer()
                HStack(spacing: 12) {
                    ForEach(viewModel.routes) { route in
                        WalkBox(
                            route: route,
                            onTap: {
                                print("✅ \(route.title) 선택됨")
                                viewModel.selectRoute(route)
                            },
                            isSelected: .constant(viewModel.selectedRoute.title == route.title)
                        )
                    }
                }
                
                .padding(.bottom, 56)
                
            }
         
            
        }
    }
}


#Preview {
    WalkingView(viewModel: WalkViewModel())
}
