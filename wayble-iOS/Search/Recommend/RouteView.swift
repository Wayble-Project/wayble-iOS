//
//  RouteView.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/13/25.
//

import Foundation
import SwiftUI

struct RouteView: View {
    @StateObject var viewModel = TransportationViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing:0) {
                ForEach(viewModel.transportation.recommendedRoutes) { route in
                    VStack(alignment: .leading) {
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
                        
                        ForEach(Array(route.steps.enumerated()), id: \.element.id) { idx, step in
                            HStack(alignment: .top, spacing: 12) {
                                // Left: Icon + Line
                                VStack(spacing: 0) {
                                    stepImage(for: step)
                                        .padding(.bottom, 4)
                                    
                                    Text(step.title)
                                        .font(.mainTextSemibold12)
                                        .lineSpacing(-2)
                                        .padding(.bottom, 2)

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

                                // Right: Station Info
                                VStack(alignment: .leading, spacing: 6) {
                                    VStack(alignment: .leading, spacing: 3) {
                                        Text(step.subTitle)
                                            .font(.mainTextSemibold14)
                                            .padding(.top, step.title.contains("홍대정문") ? 2 : (step.title.contains("도착") ? 6 : 0))

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
                    .padding(.leading, 20.0)
                    .padding(.vertical, 30.0)
                    Rectangle()
                        .foregroundStyle(Color.clear)
                        .frame(height: 2)
                        .background(Color.gray300)
                }
                
            }
        }
        .onAppear {
            viewModel.loadMockRoutes()
        }
    }
    
    private func stepImage(for step: RouteStep) -> some View {
        if step.type == .walk && step.title.contains("도착") {
            return AnyView(
                Image("fin")
                   
                    .frame(width: 18, height: 20)
                    
            )
        }
        
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
}
