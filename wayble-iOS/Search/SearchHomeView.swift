//
//  SearchHomeView.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/11/25.
//

import SwiftUI

struct SearchHomeView: View {
    @State private var searchText: String = ""

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
                .frame(height: 11)
            HStack {
                Image("wableLogo3")
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

            Button(action: {
                // 라우터 만들어지면 작성
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
                .cornerRadius(15)
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
    SearchHomeView()
}
