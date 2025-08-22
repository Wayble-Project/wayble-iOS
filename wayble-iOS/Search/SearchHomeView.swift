//
//  SearchHomeView.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/11/25.
//

import SwiftUI
import AVKit


struct SearchHomeView: View {
    @State private var searchText: String = ""
    @EnvironmentObject var searchRoute: SearchRouteState
    @Binding var selectedIndex: Int
    

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
                .frame(height: 11)
            
            
            //상단
            HStack {
                Image("waybleLogo3")
                    .resizable()
                    .frame(width: 26, height: 17)
              
                Text("wayble")
                    .font(.mainTextSemibold20)
            }
            .padding(.horizontal, 24)
            
            Spacer()
                .frame(height: 52)
            
            Text("당신을 위한 길을 안내해드려요!")
                .font(.mainTextSemibold24)
                .padding(.horizontal, 24)
            
            Spacer()
                .frame(height: 20)

            // 상단 홍대입구역
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    searchRoute.entryPoint = .directions
                    selectedIndex = 5
                }
            }) {
                HStack(alignment: .center) {
                    Text("홍대입구역")
                        .foregroundStyle(Color("gray-500"))
                        .font(.mainTextRegular14)
                    
                    Spacer()

                    Image("search")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity, minHeight: 51, maxHeight: 51)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .inset(by: 0.5)
                        .stroke(Color("gray-200"), lineWidth: 1)
                )
            }
            
            .padding(.horizontal, 24)
            .buttonStyle(PlainButtonStyle())

            Spacer()
                .frame(height:80)
            GeometryReader { geo in
                MP4View(filename: "Search", fileExtension: "mp4", size: geo.size)
                    .clipped()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .clipped()
            .padding(.bottom, 54)
        }
       
    }
}

