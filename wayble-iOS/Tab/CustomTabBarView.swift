//
//  CustomTabBarView.swift
//  wayble_iOS
//
//  Created by 신민정 on 7/9/25.
//

import SwiftUI
import Foundation


struct CustomTabBarView: View {
    @Environment(NavigationRouter.self) private var router
    @Binding var selectedIndex: Int
    
    var body: some View {
        ZStack {
            CurvedTabBarShape()
                .fill(Color.white)
                .frame(width: 349, height:64)
                .cornerRadius(15)
            
            HStack {
                // 홈
                VStack(spacing: 4) {
                    Button(action: {
                        withAnimation(.default){
                            selectedIndex = 0
                        }
                    }) {
                        VStack(spacing: 4) {
                            Image("home")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(selectedIndex == 0 ? Color("darkblue-500") : .gray500)
                        }
                    }
                    .buttonStyle(.plain)
                    
                    Text("홈")
                        .font(.mainTextRegular12)
                        .foregroundStyle(selectedIndex == 0 ? Color("darkblue-500") : .gray500)
                }
                .frame(maxWidth: .infinity)
                
                // 지도
                VStack(spacing: 4) {
                    Spacer().frame(height: 24) // 위에 버튼 공간 확보만
                    Text("지도")
                        .font(.mainTextRegular12)
                        .foregroundStyle(selectedIndex == 1 ? Color("darkblue-500") : .gray500)
                }
                .frame(maxWidth: .infinity)
                
                // 내정보
                VStack(spacing: 4) {
                    Button(action: {
                        withAnimation(.default) {
                            selectedIndex = 2
                        }
                    }) {
                        VStack(spacing: 4) {
                            Image("user")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(selectedIndex == 2 ? Color("darkblue-500") : .gray500)
                        }
                    }
                    .buttonStyle(.plain)
                    
                    Text("내정보")
                        .font(.mainTextRegular12)
                        .foregroundStyle(selectedIndex == 2 ? Color("darkblue-500") : .gray500)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 30)
            
            Button(action: {
                withAnimation(.default) {
                    selectedIndex = 1
                }
            }) {
                ZStack {
                    Circle()
                        .fill(Color("darkblue-500"))
                        .frame(width: 52, height: 52)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)
                    
                    Image("map01")
                        .resizable()
                    .frame(width: 24, height: 24)                }
            }
            .offset(y: -35)
        }
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: -7)
        .offset(y: -26)
        
    }
    
}

#Preview {
    CustomTabBarView(selectedIndex: .constant(1))
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color.gray.opacity(0.1))
        .withRouter(selectedIndex: .constant(0),router: NavigationRouter())
}
