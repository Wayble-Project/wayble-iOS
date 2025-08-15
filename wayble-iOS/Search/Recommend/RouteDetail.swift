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
    let route: RouteOption
    @State private var expandedIndex: Int? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                headerView
                Divider()
                stepsListView
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

// MARK: - Subviews (split to reduce type-check complexity)
private extension RouteDetail {
    var headerView: some View {
        HStack(spacing: 8) {
            Image("back2")
                .onTapGesture { onBack?() ?? dismiss() }

            Text("[추천경로]")
                .font(.mainTextRegular12)
                .foregroundStyle(Color.gray700)

            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 30)
    }

    var stepsListView: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(route.steps.enumerated()), id: \.offset) { i, step in
                stepRow(step: step, index: i, isLast: i == route.steps.count - 1, prevStep: i > 0 ? route.steps[i - 1] : nil)
                    .padding(.vertical, 6)
            }
        }
        .padding(.horizontal, 20)
     
    }

    @ViewBuilder
    func stepRow(step: RouteStep, index: Int, isLast: Bool, prevStep: RouteStep?) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            stepHeader(step: step, isFirst: index == 0, isLast: isLast, prevStep: prevStep)
            stepDetail(step: step)
        }
    }

    @ViewBuilder
    func stepHeader(step: RouteStep, isFirst: Bool, isLast: Bool, prevStep: RouteStep?) -> some View {
        HStack(alignment: .center, spacing: 12) {
            // LEFT COLUMN (icon + rail/labels)
            if step.type == .subway {
                // Subway: icon + line label + vertical rail (50/70)
                VStack(spacing: 2) {
                    stepImage(for: step)
                        .frame(width: 18, height: 20)
                    // 호선 라벨("서울 지하철"/"수도권 전철" 제거 후 표기)
                    Text(cleanedLineName(step.title))
                        .font(.mainTextSemibold12)
                        .foregroundStyle(Color.gray900)
                    let color: Color = {
                        let raw = cleanedLineName(step.title)
                        return step.subwayLine?.color ?? subwayColor(from: raw)
                    }()
                    // short cap above marker (50)
                    Rectangle().fill(color).frame(width: 3, height: 100)
                }

            } else if step.type == .walk {
                VStack(spacing: 2) {
                    if isFirst {
                        Image("start").frame(width: 16, height: 20)
                        Text("출발").font(.mainTextSemibold12).foregroundStyle(Color.positive)
                        Image(.dot3)
                    } else if isLast {
                        Image("fin").frame(width: 18, height: 20)
                        Text("도착").font(.mainTextSemibold12).foregroundStyle(Color.error)
                    } else {
                        stepImage(for: step).frame(width: 18, height: 20)
                        // Walk after subway: show previous subway line name under the marker
                        if prevStep?.type == .subway {
                            Text(cleanedLineName(prevStep?.title ?? prevStep?.subTitle ?? ""))
                                .font(.mainTextSemibold12)
                                .foregroundStyle(Color.gray900)
                        } else {
                            Image("dot3")
                        }
                    }
                }
            
            } else {
                stepImage(for: step).frame(width: 18, height: 20)
            }

            // RIGHT COLUMN (titles)
            VStack(alignment: .leading, spacing: 2) {
                if step.type == .walk {
                    // 출발/도착 외의 walk는 from + "하차"로 표시
                    let baseText = step.subTitle ?? step.title
                    let parts: [String] = {
                        if baseText.contains("->") { return baseText.components(separatedBy: "->").map { $0.trimmingCharacters(in: .whitespaces) } }
                        if baseText.contains("→") { return baseText.components(separatedBy: "→").map { $0.trimmingCharacters(in: .whitespaces) } }
                        return [baseText]
                    }()
                    if isFirst {
                        Text(parts.first ?? baseText)
                            .font(.mainTextSemibold12)
                            .foregroundStyle(Color.gray900)
                    } else if isLast {
                        Text(parts.count > 1 ? parts.last! : baseText)
                            .font(.mainTextSemibold12)
                            .foregroundStyle(Color.gray900)
                    } else {
                        Text((parts.first ?? baseText) + " 하차")
                            .font(.mainTextSemibold12)
                            .foregroundStyle(Color.gray900)
                    }
                } else if step.type == .subway {
                    // Subway: from + "승차"
                    let base = step.subTitle ?? step.title
                    let parts: [String] = {
                        if base.contains("->") { return base.components(separatedBy: "->").map { $0.trimmingCharacters(in: .whitespaces) } }
                        if base.contains("→") { return base.components(separatedBy: "→").map { $0.trimmingCharacters(in: .whitespaces) } }
                        return [base]
                    }()
                    let fromStation = parts.first ?? base
                    Text(fromStation + "역 승차")
                        .font(.mainTextSemibold14)
                        .foregroundStyle(Color.gray900)
                    if let cnt = step.moveCount, cnt > 0 {
                        Text("\(cnt)정거장").font(.mainTextRegular12).foregroundStyle(Color("gray600"))
                    }
                } else {
                    Text(step.title)
                        .font(.mainTextSemibold14)
                        .foregroundStyle(Color.gray900)
                    if let cnt = step.moveCount, cnt > 0 {
                        Text("\(cnt)정거장").font(.mainTextRegular12).foregroundStyle(Color("gray600"))
                    }
                }
            }
            Spacer()
        }
    }

    private func cleanedLineName(_ name: String) -> String {
        var s = name
        let patterns = ["서울지하철", "서울 지하철", "수도권 전철", "지하철", "전철"]
        for p in patterns { s = s.replacingOccurrences(of: p, with: "") }
        s = s.trimmingCharacters(in: .whitespaces)
        // normalize named lines
        if s.contains("경의중앙선") { s = s.replacingOccurrences(of: "경의중앙선", with: "경의중앙") }
        return s
    }
    
    private func subwayColor(from name: String) -> Color {
        if let range = name.range(of: "[0-9]+(?=호선)", options: .regularExpression),
           let num = Int(name[range]), (1...9).contains(num) {
            return Color("line\(num)")
        }
        if name.contains("경의중앙") { return Color("line10") }
        return .gray
    }

    @ViewBuilder
    func stepDetail(step: RouteStep) -> some View {
        switch step.type {
        case .bus:
            BusStepView(step: step)
        case .subway:
            SubwayStepView(step: step)
        case .walk:
            WalkStepView(step: step)
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
                let raw = cleanedLineName(step.title)
                return step.subwayLine?.color ?? subwayColor(from: raw)
            case .bus:
                return step.busType?.color ?? .gray
            case .walk:
                return .gray
            }
        }()
        return AnyView(
            ZStack(alignment: .center) {
                Image("check04")
                    .renderingMode(.template)
                    .foregroundStyle(color)
                Image("check03")
                    .renderingMode(.original)
                    .offset(x: -1.2, y: 2.5)
            }
                .frame(width: 16, height: 16)
        )
    }
}

    
struct BusStepView: View {
    let step: RouteStep
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // 상단: 역 이름 표시 (출발이면 왼쪽, 도착이면 오른쪽)
            HStack(spacing: 8) {
                let base = step.subTitle ?? step.title
                let parts: [String] = {
                    if base.contains("->") { return base.components(separatedBy: "->").map { $0.trimmingCharacters(in: .whitespaces) } }
                    if base.contains("→") { return base.components(separatedBy: "→").map { $0.trimmingCharacters(in: .whitespaces) } }
                    return [base]
                }()
                let station: String = {
                    if step.isDeparture == true { return parts.first ?? base }
                    if step.isFinal == true { return parts.count > 1 ? parts.last! : base }
                    return base
                }()

                Text(station)
                    .font(.mainTextSemibold14)
                    .foregroundStyle(Color.gray900)

                if step.isFinal == true {
                    Text("하차")
                        .font(.mainTextSemibold12)
                        .foregroundStyle(Color.gray700)
                }
            }

            // 하단: 정거장 개수 및 목록 (토글)
            if let stops = step.stops, !stops.isEmpty {
                HStack(spacing: 0) {
                    TrainStopToggleView(stops: stops)
                }
            }
        }
        .padding(.top, 2)
    }
}

struct SubwayStepView: View {
    let step: RouteStep
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                let base = step.subTitle ?? step.title
                let parts: [String] = {
                    if base.contains("->") { return base.components(separatedBy: "->").map { $0.trimmingCharacters(in: .whitespaces) } }
                    if base.contains("→") { return base.components(separatedBy: "→").map { $0.trimmingCharacters(in: .whitespaces) } }
                    return [base]
                }()
                            }
            if let stops = step.stops, !stops.isEmpty {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(Array(stops.enumerated()), id: \.offset) { _, s in
                        Text("• \(s)")
                            .font(.mainTextRegular12)
                            .foregroundStyle(Color("gray800"))
                    }
                }
            }
        }
        .padding(.top, 2)
    }
}

struct WalkStepView: View {
    let step: RouteStep
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(step.title)
                .font(.mainTextRegular12)
                .foregroundStyle(Color("gray800"))
        }
        .padding(.top, 2)
    }
}

#Preview {
    // 간단한 샘플 RouteOption (필요 시 프로젝트의 SampleRoutes를 사용)
    let sampleSteps: [RouteStep] = []
    let sample = RouteOption(totalTime: 0, arrivalTime: "-", cost: 0, steps: sampleSteps)
    return RouteDetail(route: sample)
}
