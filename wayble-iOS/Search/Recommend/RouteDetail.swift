//
//  RouteDetail.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/15/25.
//
import Foundation
import SwiftUI

struct RouteDetail: View {
    var onBack: (() -> Void)? = nil
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel = TransportationViewModel()
    @State private var isSimpleMode = false
    
    var body: some View {
        ScrollView {
            VStack(spacing:0) {
                if let route = viewModel.transportation.recommendedRoutes.first {
                    VStack(alignment: .leading) {
                        //소요시간, 도착 - 상태 바
                        HStack {
                            
                            Image("back2")
                                .onTapGesture {
                                    onBack?()
                                    }
                            
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

                        ForEach(route.steps, id: \.id) { step in
                            stepView(for: step)
                        }
                        
                    }
                    .padding(.leading, 20.0)
                    .padding(.vertical, 30.0)
                }
            }
        }
        .onAppear {
            viewModel.loadMockRoutes()
            isSimpleMode = false // Always show full detail in RouteDetail
        }
        .navigationBarBackButtonHidden(true)
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
    RouteDetail()
}

@ViewBuilder
private func stepView(for step: RouteStep) -> some View {
    if step.destFinal == true {
        CommonStepView(step: step)
    } else if step.showDest == true {
        EmptyView() 
    } else if step.type == .subway && step.isFinal {
        CommonStepView(step: step)
    } else if step.type == .bus && step.isFinal {
        CommonStepView(step: step)
    } else if step.isDeparture {
        if step.type == .subway {
            SubwayStepView(step: step)
        } else if step.type == .bus {
            BusStepView(step: step)
        } else {
            CommonStepView(step: step)
        }
    } else {
        CommonStepView(step: step)
    }
}
