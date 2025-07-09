//
//  CustomTabBarView.swift
//  wayble_iOS
//
//  Created by 신민정 on 7/9/25.
//

import SwiftUI

struct CustomTabBarView: View {
    @Binding var selectedIndex: Int
    
    var body: some View {
        ZStack {
            CurvedTabBarShape()
                .fill(Color.white)
                .frame(width: 349, height:64)
                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: -7)
                .cornerRadius(15)

            HStack {
                // 홈
                VStack(spacing: 4) {
                    Button {
                        selectedIndex = 0
                    } label: {
                        VStack(spacing: 4) {
                            Image("home")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(selectedIndex == 0 ? Color("darkblue") : .gray)
                        }
                    }
                    .buttonStyle(.plain)

                    Text("홈")
                        .font(.mainTextRegular12)
                        .foregroundStyle(selectedIndex == 0 ? Color("darkblue") : .gray)
                }
                .frame(maxWidth: .infinity)

                // 지도
                VStack(spacing: 4) {
                    Spacer().frame(height: 24) // 위에 버튼 공간 확보만
                    Text("지도")
                        .font(.mainTextRegular12)
                        .foregroundStyle(selectedIndex == 1 ? Color("darkblue") : .gray)
                }
                .frame(maxWidth: .infinity)

                // 내정보
                VStack(spacing: 4) {
                    Button {
                        selectedIndex = 2
                    } label: {
                        VStack(spacing: 4) {
                            Image("user")
                                .renderingMode(.template)
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundStyle(selectedIndex == 2 ? Color("darkblue-500") : .gray)
                        }
                    }
                    .buttonStyle(.plain)

                    Text("내정보")
                        .font(.mainTextRegular12)
                        .foregroundStyle(selectedIndex == 2 ? Color("darkblue") : .gray)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 30)

            Button(action: {
                selectedIndex = 1
            }) {
                ZStack {
                    Circle()
                        .fill(Color("darkblue"))
                        .frame(width: 52, height: 52)
                        .shadow(color: .black.opacity(0.2), radius: 8, x: 0, y: 4)

                    if selectedIndex == 1 {
                        Image("waybleLogo")
                            .resizable()
                            .frame(width: 27.4, height: 17.9)
                    } else {
                        Image("map01")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }                }
            }
            .offset(y: -35)
        }    }
    
    
    
}

#Preview {
    CustomTabBarView(selectedIndex: .constant(1))
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color.gray.opacity(0.1))
}
