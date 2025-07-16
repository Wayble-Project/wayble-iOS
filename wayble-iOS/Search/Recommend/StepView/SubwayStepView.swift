//
//  SubwayStepView.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/16/25.
//

import SwiftUI
import Foundation


struct SubwayStepView: View {
    let step: RouteStep
    @StateObject var viewModel = TransportationViewModel()
    @State private var isSimpleMode = false
    
    var body: some View {
        ScrollView {
            VStack(spacing:0) {
                if let route = viewModel.transportation.recommendedRoutes.first {
                    VStack(alignment: .leading) {
                        let visibleSteps = route.steps.filter { $0.type == .subway && $0.isDeparture == true }
                        ForEach(Array(visibleSteps.enumerated()), id: \.element.id) { idx, step in
                            
                            
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
                                        if idx < route.steps.count - 1 {
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
                                                    
                                                
                                                Rectangle()
                                                    .fill(color)
                                                    .frame(width: 3, height: 151)
                                                    
                                            }
                                            .padding(.bottom, 4)
                                        }
                                    }
                                    .frame(width: 50, alignment: .center)
                                    
                                    // 오른쪽 정보들 (VStack)
                                    VStack(alignment: .leading, spacing: 6) {
                                        VStack(alignment: .leading, spacing: 3) {
                                            Text("\(step.subTitle) 승차") // 상수역
                                                .font(.mainTextSemibold14)
                                            Spacer()
                                                .frame(height:12)
                                            
                                            HStack(spacing: 7) {
                                 
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
                                            
                                            Spacer()
                                                .frame(height:17)
                                            
                                            if step.type == .subway && step.isDeparture == true {
                                                VStack(alignment: .leading, spacing: 3) {
                                                    if let chair = step.chair {
                                                        HStack(spacing:5){
                                                            Image("chair04")
                                                            
                                                            Text(chair)
                                                                .font(.mainTextSemibold12)
                                                                .foregroundStyle(Color.blue700)
                                                        }
                                                    }
                                                    Spacer()
                                                        .frame(height:5)
                                                    if let elevator = step.elevator {
                                                        
                                                        HStack(spacing:5) {
                                                            Image("lift04")
                                                        
                                                        Text(elevator)
                                                            .font(.mainTextSemibold12)
                                                            .foregroundStyle(Color.blue700)
                                                    }
                                                }
                                                    Spacer()
                                                        .frame(height:5)
                                                    if let toilet = step.toilet {
                                                        
                                                        HStack(spacing:5) {
                                                            Image("chair04")
                                                            
                                                            Text(toilet)
                                                                .font(.mainTextSemibold12)
                                                                .foregroundStyle(Color.blue700)
                                                        }
                                                    }
                                                    Spacer()
                                                        .frame(height:9)
                                                    // ~개 역 이동 와프 나오면 수정
                                                    
                                                    HStack(spacing:7) {
                                                        Text("5개 역 이동")
                                                            .font(.mainTextRegular10)
                                                            .offset(x:3)
                                                        
                                                        Image("down")
                                                    }
                                                }
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
                    }
                  
                }
            }
        }
        .onAppear {
            viewModel.loadMockRoutes()
            isSimpleMode = false // Always show full detail in RouteDetail
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
        
        //출발일 경우 파란 핀으로 수정
        if step.title.contains("출발") {
            return AnyView(
                Image("start")
                    .frame(width: 16, height: 20)
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
    SubwayStepView(step: RouteStep(type: .subway, title: "6호선", subTitle: "상수역", detail: "엘리베이터 있음", extra: "14:56", Info: "응암행(광흥창역 방면)", extraBus: nil, busTime: nil, role: .subway, isDeparture: true, chair: "휠체어 전용석 6-1, 10-4", toilet: "장애인 화장실 O",elevator: "엘리베이터와 가까운 승강장 8-1", simple: true))
}
