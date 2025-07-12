//
//  SearchBarView.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/11/25.
//

import SwiftUI

struct SearchBarView: View {
    @State private var viewModel = SearchViewModel()
    var body: some View {
        
        Spacer()
            .frame(height: 12)
            VStack {
                HStack{
                    HStack() {
                        Button(action: {
                            // 여기에 dismiss() 추가 예정
                        }) {
                            Image("back2")
                                .resizable()
                                .frame(width: 24, height: 24)
                        }
                        
                        
                        TextField("ex.숙대입구역 맛집", text: $viewModel.searchText)
                            .foregroundStyle(Color.gray500)
                            .font(.mainTextRegular14)
                        
                        Spacer()
                        
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 15)
                    .frame(maxWidth: .infinity, maxHeight: 50)
                    .background(Color.white)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .inset(by: 0.5)
                            .stroke(Color.gray300, lineWidth: 1)
                    )
                    Spacer()
                        .frame(width:10)
                    Button(action: {}) {
                        Image("map02")
                            .padding(.horizontal, 12)
                            .padding(.vertical, 15)
                            .frame(width: 50, height: 50, alignment: .center)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .inset(by: 0.5)
                                    .stroke(Color.gray300, lineWidth: 1)
                                
                            )
                    }
                }
                .padding(.horizontal, 20)
                
                
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(maxWidth: .infinity)
                    .frame(height: 12)
                    .background(.white)
                    .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 6)
                
                Spacer()
                    .frame(height: 24)
                
                
                HStack(spacing: 16) {
                    Button(action: {}) {
                            FilterTagView(label: "집")
                        }
                    Button(action: {}) {
                            FilterTagView(label: "회사")
                        }
                    Button(action: {}) {
                            FilterTagView(label: "학교")
                        }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
                
                Spacer()
                    .frame(height: 14)
                
                VStack(spacing: 0) {
                    SearchRow(icon: "search", title: "음식점", date: "06.27")
                    Divider()
                    SearchRow(icon: "location", title: "카페 아임히어", date: "06.11")
                }

                Spacer()
            }
            .padding(.top)
        }
}

struct FilterTagView: View {
    let label: String
    
    var body: some View {
        Text(label)
            .font(.mainTextSemibold14)
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.white)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .background(Color.blue500)
            .cornerRadius(40)
    }
}

struct SearchRow: View {
    let icon: String
    let title: String
    let date: String

    var body: some View {
        HStack {
            Image(icon)
            Spacer()
                .frame(width: 17)
            Text(title)
                .font(.mainTextRegular16)
            Spacer()
            Text(date)
                .foregroundStyle(Color.gray700)
        }
        .padding(.vertical, 14)
        .padding(.leading,26)
        .padding(.trailing, 20.0)
        
    }
}

#Preview {
    SearchBarView()
}
