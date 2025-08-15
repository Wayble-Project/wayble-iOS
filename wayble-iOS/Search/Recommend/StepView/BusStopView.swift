//
//  BusStepView.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/16/25.
//
import Foundation
import SwiftUI

struct BusStopView: View {
    let step: RouteStep
    @Bindable var viewModel = TransportationViewModel()
    @State private var isSimpleMode = false
    
    private var visibleBusSteps: [RouteStep] {
        viewModel.transportation.recommendedRoutes.first?
            .steps
            .filter { $0.type == .bus && $0.isDeparture == true } ?? []
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing:0) {
                VStack(alignment: .leading) {
                    ForEach(0..<visibleBusSteps.count, id: \.self) { idx in
                        let step = visibleBusSteps[idx]
                        let isLast = idx == visibleBusSteps.count - 1
                        BusStepRow(step: step, isLast: isLast)
                    }
                }
            }
        }
        .onAppear {
            viewModel.loadMockRoutes()
            isSimpleMode = false // Always show full detail in RouteDetail
        }
    }
}

private struct BusStepRow: View {
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
        .animation(.easeInOut(duration: 0.2), value: contentHeight)
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

                if let title = step.bustitle {
                    Text(title)
                        .font(.mainTextSemibold12)
                        .lineSpacing(-2)
                        .padding(.bottom, 2)
                }

                Rectangle()
                    .fill(lineColor(for: step))
                    .frame(width: 3, height: max(0, lineHeight - 40))
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

    // PreferenceKey for measuring right column height
    private struct RowHeightKey: PreferenceKey {
        static var defaultValue: CGFloat = 0
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = max(value, nextValue())
        }
    }

    // MARK: - Right
    private struct RightColumn: View {
        let step: RouteStep

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("\(step.subTitle) 승차")
                        .font(.mainTextSemibold14)
                    Spacer().frame(height: 16)
                }

                VStack(alignment: .leading) {
                    HStack {
                        if let extraBus = step.extraBus {
                            Image("bus").frame(width: 20, height: 20)
                            Spacer().frame(width: 5)
                            if let transfers = step.transfer, let firstTransfer = transfers.first {
                                Text(firstTransfer)
                                    .font(.mainTextSemibold12)
                                    .foregroundStyle(Color.black)
                            }
                            Spacer().frame(width: 10)
                            Text(extraBus)
                                .font(.mainTextSemibold12)
                                .foregroundStyle(Color.blue700)
                            Spacer().frame(width: 7)
                            Rectangle().fill(Color.gray200).frame(width: 1, height: 10)
                        }
                        if let busTime = step.busTime {
                            Text(busTime)
                                .font(.mainTextRegular12)
                                .foregroundStyle(Color.gray700)
                        }
                    }

                    HStack(alignment: .top) {
                        HStack {
                            Image("bus").frame(width: 20, height: 20)
                            Spacer().frame(width: 5)
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

                Spacer().frame(height: 17)
                BusStopToggleView(stops: ["서교동주민센터", "삼진제약", "꿈나무종합타운"])

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
BusStopView(step: RouteStep(type: .walk, title: "도착", subTitle:"홍대정문", detail: nil, extra: nil, Info: nil, extraBus: nil, busTime: nil, simple: true, showDest: true))
}
