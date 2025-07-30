//
//  Transportation.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/13/25.
//

import SwiftUI

struct Transportation: View {
    var onBack: (() -> Void)? = nil
    @StateObject var viewModel = TransportationViewModel()
    @State private var showDetail: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            // 파란 헤더 (출발/도착/엑스버튼)
            VStack(spacing: 0) {
                HStack(alignment: .top) {
                    Button(action: {
                        viewModel.swapLocations()
                    }) {
                        Image("switch")
                            .resizable()
                            .frame(width: 26, height: 26)
                    }
                    .padding(.top, 8)
                    .offset(y: 30)
                    
                    Spacer()
                        .frame(width: 5)
                    VStack(spacing: 0) {
                        HStack(alignment: .center) {
                            Text(viewModel.transportation.departure)
                                .foregroundStyle(Color("darkblue-500"))
                                .font(.mainTextSemibold14)
                            
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .frame(width: 269, height: 51)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .inset(by: 0.5)
                                .stroke(Color.gray200, lineWidth: 1)
                        )
                        
                        HStack() {
                            Text(viewModel.transportation.destination)
                                .foregroundStyle(Color("darkblue-500"))
                                .font(.mainTextSemibold14)
                            Spacer()
                        }
                        .padding(.horizontal, 20)
                        .frame(width: 269, height: 51)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .inset(by: 0.5)
                                .stroke(Color.gray200, lineWidth: 1)
                        )
                        .padding(.bottom, 10)
                    }
                    
                    Spacer()
                        .frame(width: 15)
                    
                    Button(action: {
                        //엑스버튼액션넣기
                    }) {
                        Image("xButton")
                            .resizable()
                            .frame(width: 26, height: 26)
                    }
                    .padding(.top, 8)
                    .offset(y: 5)
                }
                .padding(.vertical, 12)
            }
            .frame(maxWidth: .infinity)
            .background(Color("blue-50"))
            
            // 탭 바 (대중교통 | 도보)
            VStack(spacing: 0) {
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    ForEach(TransportationTab.allCases.indices, id: \.self) { index in
                        let tab = TransportationTab.allCases[index]
                        Button(action: {
                            viewModel.setTab(to: tab)
                        }) {
                            VStack(spacing:0) {
                                Spacer()
                                    .frame(height:11)
                                Text(tab.rawValue)
                                    .font(.mainTextSemibold14)
                                    .foregroundColor(viewModel.transportation.selectedTab == tab ? .black : .gray300)
                                    .lineLimit(1)
                                    .fixedSize()
                                    .frame(height: 22)
                                Spacer()
                                    .frame(height:11)
                                Rectangle()
                                    .frame(width: 130, height: 2)
                                    .foregroundColor(viewModel.transportation.selectedTab == tab ? .black : .clear)
                                
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        if index < TransportationTab.allCases.count - 1 {
                            Rectangle()
                                .fill(Color.gray300)
                                .frame(width: 1, height: 14)
                        }
                    }
                }
                .padding(.horizontal)
                .background(Color.white)
                
                Rectangle()
                    .fill(Color.gray300)
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
            }
            
            // 아래 영역: RouteDetail 또는 RouteView
            if showDetail {
                RouteDetail(onBack: { showDetail = false })
            } else {
                if viewModel.transportation.selectedTab == .walking {
                    WalkingView() // 도보 탭일 때 
                } else {
                    RouteView(onRouteSelected: { showDetail = true })
                }
            }
        }
    }
}

#Preview {
    Transportation()
        .environment(NavigationRouter())
}
