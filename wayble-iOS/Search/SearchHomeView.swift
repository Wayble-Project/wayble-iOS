//
//  SearchHomeView.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/11/25.
//

import SwiftUI
import Gifu
import UIKit


struct SearchHomeView: View {
    @State private var searchText: String = ""
    @Binding var selectedIndex: Int
    

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
                .frame(height: 11)
            
            SafeGIFView(gifName: "way")
                .frame(width: 200, height: 200)
            
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
            selectedIndex = 5 
            }) {
                HStack(alignment: .center) {
                    Text("홍대입구역")
                        .foregroundStyle(Color.gray500)
                        .font(.mainTextRegular14)
                    
                    Spacer()

                    Image("search")
                        .resizable()
                        .frame(width: 24, height: 24)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .frame(width: 350, height: 51)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .inset(by: 0.5)
                        .stroke(Color.gray200, lineWidth: 1)
                )
            }
            
            .padding(.horizontal, 24)
            .buttonStyle(PlainButtonStyle())

            Spacer()

            Image("searchHome")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 402.42425537109375, height: 415)
                .clipped()
                .padding(.bottom,54)
            
                

        }
    }
}

#Preview {
    SearchHomeView(selectedIndex: .constant(0))
        .withRouter(selectedIndex: .constant(0))
}
