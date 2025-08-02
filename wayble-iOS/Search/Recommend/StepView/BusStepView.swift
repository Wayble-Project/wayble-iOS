//
//  BusStepView.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/16/25.
//
import Foundation
import SwiftUI

struct BusStepView: View {
    let step: RouteStep
    @Bindable var viewModel = TransportationViewModel()
    @State private var isSimpleMode = false
    
    var body: some View {
        ScrollView {
            VStack(spacing:0) {
                if let route = viewModel.transportation.recommendedRoutes.first {
                    VStack(alignment: .leading) {
                        
                    

                        let visibleSteps = route.steps.filter { $0.type == .bus && $0.isDeparture == true }
                        ForEach(Array(visibleSteps.enumerated()), id: \.element.id) { idx, step in
                            
                                //역이나 정류장 별로 HStack 으로 묶기
                                HStack(alignment: .top, spacing: 12) {
                                    
                                    // 왼쪽 VStack 모음
                                    VStack(spacing: 0) {
                                        stepImage(for: step)
                                            .padding(.bottom, 4)
                                        
                                        if let title = step.bustitle {
                                            Text(title)
                                                .font(.mainTextSemibold12)
                                                .lineSpacing(-2)
                                                .padding(.bottom, 2)
                                        }
                                        
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
                                                    .frame(width: 3, height: 101)
                                            }
                                      
                                        }
                                    }
                                    .frame(width: 50, alignment: .center)
                                    
                                    // 오른쪽 정보들 (VStack)
                                    VStack(alignment: .leading, spacing: 0) {
                                        VStack(alignment: .leading, spacing: 3) {
                                            Text("\(step.subTitle) 승차") // 상수역
                                                .font(.mainTextSemibold14)
                                            Spacer()
                                                .frame(height:16)
                                      
                                            
                                            if step.type == .subway && step.isDeparture == true {
                                                VStack(alignment: .leading, spacing: 3) {
                                  
                                            
                                                }
                                            }
                                        }
                                        
                                        
                                        //버스일경우
                                        VStack(alignment:.leading){
                                            
                                            HStack {
                                                if let extraBus = step.extraBus {
                                                    
                                                    Image("bus")
                                                        .frame(width: 20, height: 20)
                                                    
                                                    Spacer()
                                                        .frame(width:5)
                                                    if let transfers = step.transfer, let firstTransfer = transfers.first {
                                                        Text(firstTransfer)
                                                            .font(.mainTextSemibold12)
                                                            .foregroundStyle(Color.black)
                                                    }
                                                    
                                                    Spacer()
                                                        .frame(width:10)
                                                    Text(extraBus)
                                                        .font(.mainTextSemibold12)
                                                        .foregroundStyle(Color.blue700)
                                                    Spacer()
                                                        .frame(width:7)
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
                                            HStack(alignment: .top) {
                                                HStack {
                                                    Image("bus")
                                                        .frame(width: 20, height: 20)
                                                    
                                                    Spacer()
                                                        .frame(width:5)
                                                    if let transfers = step.transfer, transfers.count > 1 {
                                                        let secondTransfer = transfers[1]
                                                        Text(secondTransfer)
                                                            .font(.mainTextSemibold12)
                                                            .foregroundStyle(Color.black)
                                                    }
                                                    
                                                    if let busTime = step.busTime {
                                                        Text(busTime)
                                                            .font(.mainTextRegular12)
                                                            .foregroundStyle(Color.gray700)
                                                    }
                                                }
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            }
                                        }
                                        Spacer()
                                            .frame(height:16)
                                        HStack(spacing:7) {
                                            Text("5개 정류장 이동")
                                                .font(.mainTextRegular10)
                                                .offset(x:3)
                                            
                                            Image("down")
                                                .frame(width: 14, height: 14)
                                            
                                        }
                                        Spacer()
                                            .frame(height:16)
                                    // 버스나 지하철일경우 밑줄 긋기
                                        if step.type == .subway || step.type == .bus {
                                            Rectangle()
                                                .fill(Color.gray200)
                                                .frame(height: 1)
                                                .padding(.top, 10.0)
                                        }
                                    }
                                }
                               
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
BusStepView(step: RouteStep(type: .walk, title: "도착", subTitle:"홍대정문", detail: nil, extra: nil, Info: nil, extraBus: nil, busTime: nil, simple: true, showDest: true))
}
