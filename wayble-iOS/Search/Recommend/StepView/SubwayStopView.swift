//
//  SubwayStepView.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/16/25.
//

import SwiftUI
import Foundation


struct SubwayStopView: View {
    let step: RouteStep
    @Bindable var viewModel = TransportationViewModel()
    @State private var isSimpleMode = false
    @State private var showStops: Bool = false
    
    private var visibleSubwaySteps: [RouteStep] {
        viewModel.transportation.recommendedRoutes.first?
            .steps
            .filter { $0.type == .subway && $0.isDeparture == true } ?? []
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing:0) {
                VStack(alignment: .leading) {
                    ForEach(0..<visibleSubwaySteps.count, id: \.self) { idx in
                        let step = visibleSubwaySteps[idx]
                        
                        SubwayStepRow(step: step, isLast: idx == visibleSubwaySteps.count - 1)
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadMockRoutes()
            isSimpleMode = false // Always show full detail in RouteDetail
        }
    }
    
    @ViewBuilder
    private func stepImage(for step: RouteStep) -> some View {
        if step.type == .walk && step.title.contains("도착") {
            Image("fin").frame(width: 18, height: 20)
        } else if step.title.contains("출발") {
            Image("start").frame(width: 16, height: 20)
        } else {
            let color: Color = {
                switch step.type {
                case .subway: return step.subwayLine?.color ?? .gray
                case .bus: return step.busType?.color ?? .gray
                case .walk: return .gray
                }
            }()
            ZStack(alignment: .center) {
                Image("check04").foregroundColor(color)
                Image("check03").offset(x:-1.2, y:2.5)
            }
            .frame(width: 16, height: 16)
        }
    }
}

private struct SubwayStepRow: View {
    let step: RouteStep
    let isLast: Bool
    @State private var contentHeight: CGFloat = 0

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            LeftColumn(step: step, isLast: isLast, lineHeight: contentHeight)
                .frame(width: 50, alignment: .center)
            RightColumn(step: step)
                .background(
                    GeometryReader { geo in
                        Color.clear.preference(key: RowHeightKey.self, value: geo.size.height)
                    }
                )
                .onPreferenceChange(RowHeightKey.self) { contentHeight = $0 }
        }
        .padding(.trailing, 29.0)
        .animation(.easeInOut(duration: 0.2), value: contentHeight)
    }

    private struct RowHeightKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = max(value, nextValue())
        }
    }

    // MARK: - Left
    private struct LeftColumn: View {
        let step: RouteStep
        let isLast: Bool
        let lineHeight: CGFloat

        var body: some View {
            VStack(spacing: 0) {
                StepIcon(step: step)
                    .padding(.bottom, 4)

                Text(step.title)
                    .font(.mainTextSemibold12)
                    .lineSpacing(-2)
                    .padding(.bottom, 2)

                Rectangle()
                    .fill(lineColor(for: step))
                    .frame(width: 3, height: max(0, lineHeight - 42))
                    .padding(.bottom, 4)
                    .animation(.easeInOut(duration: 0.2), value: lineHeight)
            }
        }

        private func lineColor(for step: RouteStep) -> Color {
            switch step.type {
            case .subway: return step.subwayLine?.color ?? .gray
            case .bus: return step.busType?.color ?? .gray
            default: return .clear
            }
        }
    }

    // MARK: - Right
    private struct RightColumn: View {
        let step: RouteStep

        var body: some View {
            VStack(alignment: .leading, spacing: 6) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("\(step.subTitle)역 승차")
                        .font(.mainTextSemibold14)
                    Spacer().frame(height: 12)

                    HStack(spacing: 7) {
                        if let extra = step.extra { // 시간 등
                            Text(extra)
                                .font(.mainTextSemibold12)
                                .foregroundStyle(Color.error)
                        }
                        if let info = step.Info { // 행선/방면 등
                            Text(info)
                                .font(.mainTextRegular12)
                                .foregroundStyle(Color.gray700)
                        }
                    }
                    Spacer().frame(height: 17)

                    if step.type == .subway && step.isDeparture == true {
                        VStack(alignment: .leading, spacing: 3) {
                            if let chair = step.chair {
                                HStack(spacing: 5) {
                                    Image("chair04")
                                    Text(chair)
                                        .font(.mainTextSemibold12)
                                        .foregroundStyle(Color.blue700)
                                }
                            }
                            Spacer().frame(height: 5)
                            if let elevator = step.elevator {
                                HStack(spacing: 5) {
                                    Image("lift04")
                                    Text(elevator)
                                        .font(.mainTextSemibold12)
                                        .foregroundStyle(Color.blue700)
                                }
                            }
                            Spacer().frame(height: 5)
                            if let toilet = step.toilet {
                                HStack(spacing: 5) {
                                    Image("chair04")
                                    Text(toilet)
                                        .font(.mainTextSemibold12)
                                        .foregroundStyle(Color.blue700)
                                }
                            }
                            Spacer().frame(height: 3)
                           
                            HStack(spacing: 0) {
                               
                                
                                TrainStopToggleView(stops: ["상수역", "대흥역", "공덕역"]) 
                            }
                        }
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
    }

    // MARK: - Icon
    private struct StepIcon: View {
        let step: RouteStep
        var body: some View {
            if step.type == .walk && step.title.contains("도착") {
                Image("fin").frame(width: 18, height: 20)
            } else if step.title.contains("출발") {
                Image("start").frame(width: 16, height: 20)
            } else {
                ZStack(alignment: .center) {
                    Image("check04").foregroundColor(color(for: step))
                    Image("check03").offset(x: -1.2, y: 2.5)
                }
                .frame(width: 16, height: 16)
            }
        }
        private func color(for step: RouteStep) -> Color {
            switch step.type {
            case .subway: return step.subwayLine?.color ?? .gray
            case .bus: return step.busType?.color ?? .gray
            case .walk: return .gray
            }
        }
    }
}

    
#Preview {
    SubwayStopView(step: RouteStep(type: .subway, title: "6호선", subTitle: "상수역", detail: "엘리베이터 있음", extra: "14:56", Info: "응암행(광흥창역 방면)", extraBus: nil, busTime: nil, role: .subway, isDeparture: true, chair: "휠체어 전용석 6-1, 10-4", toilet: "장애인 화장실 O",elevator: "엘리베이터와 가까운 승강장 8-1", simple: true))
}
