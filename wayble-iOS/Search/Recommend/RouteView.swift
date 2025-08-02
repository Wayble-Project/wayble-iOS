//
//  RouteView.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/13/25.
//

import Foundation
import SwiftUI

struct RouteView: View {
    var onRouteSelected: (() -> Void)? = nil
    @Bindable var viewModel = TransportationViewModel()
    @Environment(NavigationRouter.self) var router
    
    var body: some View {
        ScrollView {
            VStack(spacing:0) {
                ForEach(viewModel.transportation.recommendedRoutes) { route in
                    VStack(alignment: .leading) {
                            
                            //소요시간, 도착 - 상태 바
                            HStack {
                                Text("\(route.totalTime)분")
                                    .font(.mainTextSemibold20)
                                Spacer()
                                    .frame(width: 16.5)
                                Text(route.arrivalTime)
                                    .font(.mainTextRegular12)
                                    .foregroundStyle(Color.gray700)
                                
                                Rectangle()
                                    .fill(Color.gray200)
                                    .frame(width: 1, height: 10)
                                
                                Text("\(route.cost)원")
                                    .font(.mainTextRegular12)
                                    .foregroundStyle(Color.gray700)
                            }
                            
                            Spacer()
                                .frame(height:24)
                            
                            let simpleSteps = route.steps.filter { $0.simple }
                            ForEach(Array(simpleSteps.enumerated()), id: \.element.id) { idx, step in
                                
                                //역이나 정류장 별로 HStack 으로 묶기
                                HStack(alignment: .top, spacing: 12) {
                                    
                                    // 왼쪽 VStack 모음
                                    VStack(spacing: 0) {
                                        stepImage(for: step)
                                            .padding(.bottom, 4)
                                        
                                        Text(step.title)
                                            .font(.mainTextSemibold12)
                                            .lineSpacing(-2)
                                            .padding(.bottom, 2)
                                        
                                        // 대중교통 밑에 선
                                        if idx < simpleSteps.count - 1 {
                                            let color: Color = {
                                                switch step.type {
                                                case .subway: return step.subwayLine?.color ?? .gray
                                                case .bus: return step.busType?.color ?? .gray
                                                default: return .clear
                                                }
                                            }()
                                            
                                            ZStack {
                                                
                                                Rectangle()
                                                    .fill(color)
                                                    .frame(width: 3, height: 10)
                                                    .offset(y: -10)
                                                
                                                Rectangle()
                                                    .fill(color)
                                                    .frame(width: 3, height: 36)
                                                    .offset(y: 13)
                                            }
                                            .padding(.bottom, 4)
                                        }
                                    }
                                    .frame(width: 50, alignment: .center)
                                    
                                    // 오른쪽 정보들 (VStack)
                                    VStack(alignment: .leading, spacing: 6) {
                                        VStack(alignment: .leading, spacing: 3) {
                                            Text(step.subTitle) // 상수역
                                                .font(.mainTextSemibold14)
                                          
                                            //엘레베이터 유무, 시간
                                            HStack(spacing: 7) {
                                                if let detail = step.detail {
                                                    HStack(spacing: 2) {
                                                        Image("lift")
                                                            .foregroundStyle(Color.blue700)
                                                        Text(detail)
                                                            .font(.mainTextSemibold12)
                                                            .foregroundStyle(Color.blue700)
                                                    }
                                                }
                                             
                                                //엘레베이터 표시랑 시간이나 정보 있으면 | 이거 표시
                                                if step.detail != nil && (step.extra != nil || step.Info != nil) {
                                                    Rectangle()
                                                        .fill(Color.gray200)
                                                        .frame(width: 1, height: 10)
                                                }
                                                
                                                if let extra = step.extra {
                                                    Text(extra)
                                                        .font(.mainTextSemibold12)
                                                        .foregroundStyle(Color.error)
                                                }
                                                
                                                if let info = step.Info {
                                                    Text(info)
                                                        .font(.mainTextRegular12)
                                                        .foregroundStyle(Color.gray700)
                                                }
                                            }
                                            
                                        }
                                        
                                        
                                        //버스일경우
                                        HStack {
                                            if let extraBus = step.extraBus {
                                                Text(extraBus)
                                                    .font(.mainTextSemibold12)
                                                    .foregroundStyle(Color.blue700)
                                                
                                                Rectangle()
                                                    .fill(Color.gray200)
                                                    .frame(width: 1, height: 10)
                                            }
                                            
                                            if let busTime = step.busTime {
                                                Text(busTime)
                                                    .font(.mainTextRegular12)
                                                    .foregroundStyle(Color.gray700)
                                            }
                                        }
                                        
                                    // 버스나 지하철일경우 밑줄 긋기
                                        if step.type == .subway || step.type == .bus {
                                            Rectangle()
                                                .fill(Color.gray200)
                                                .frame(height: 1)
                                                .padding(.top, 10.0)
                                        }
                                    }
                                }
                                .padding(.trailing, 29.0)
                            }
                            Spacer().frame(height: 17)  // or any value to adjust spacing
                            Rectangle() // 밑에 구분 선
                                .foregroundStyle(Color.clear)
                                .frame(height: 2)
                                .background(Color.gray300)
                    
                           
                    }
                    .padding(.leading, 20.0)
                    .padding(.top, 17)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        onRouteSelected?()
                    }
                }
                
            }
        }
        .onAppear {
            viewModel.loadMockRoutes()
        }
    }
    
    // 도착일 경우 왼쪽 이모지 "fin"으로
    private func stepImage(for step: RouteStep) -> some View {
        if step.type == .walk && step.title.contains("도착") {
            return AnyView(
                Image("fin")
                    .frame(width: 18, height: 20)
                
            )
        }
        
        //각자 탈 것에 맞는 색깔로 표시
        let color: Color = {
            switch step.type {
            case .subway:
                return step.subwayLine?.color ?? .gray
            case .bus:
                return step.busType?.color ?? .gray
            case .walk:
                return .gray
            }
        }()
        return AnyView(
            ZStack(alignment: .center) {
                Image("check04")
                    .foregroundColor(color)
                Image("check03")
                    .offset(x:-1.2, y:2.5)
            }
                .frame(width: 16, height: 16)
        )
    }
}

#Preview {
    RouteView()
        .environment(NavigationRouter())   //  이거 추가
}
