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
            HStack(){
                VStack(spacing: 0) {
                    headerView
                    Spacer().frame(maxHeight:29)
                    stepsListView
                }
                .frame(maxWidth: .infinity, alignment: .leading)
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
                .onTapGesture {
                    withAnimation(.easeInOut) {
                        onBack?() ?? dismiss()
                    }
                }

            Text("상세경로")
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
                if !(step.type == .subway && (step.title.isEmpty || step.subTitle == nil) && (step.stops == nil || step.stops?.isEmpty == true)) {
                    let prev = i > 0 ? route.steps[i - 1] : nil
                    let next = i < route.steps.count - 1 ? route.steps[i + 1] : nil
                    let isTransferWalk = (step.type == .walk) && ((prev?.type == .subway || prev?.type == .bus)) && ((next?.type == .subway || next?.type == .bus))
                    let isLeadingWalk = (step.type == .walk) && (i == 0) && ((next?.type == .subway || next?.type == .bus))
                    stepRow(step: step, index: i, isLast: i == route.steps.count - 1, prevStep: prev, nextStep: next)
                        .padding(.vertical, (isTransferWalk || isLeadingWalk) ? 0 : 6)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 28)
    }

    @ViewBuilder
    func stepRow(step: RouteStep, index: Int, isLast: Bool, prevStep: RouteStep?, nextStep: RouteStep?) -> some View {
        let isTransferWalk = (step.type == .walk) && ((prevStep?.type == .subway || prevStep?.type == .bus)) && ((nextStep?.type == .subway || nextStep?.type == .bus))
        if isTransferWalk {
            Color.clear.frame(height: 0.1)
        } else {
            VStack(alignment: .leading, spacing: 8) {
                let afterStep: RouteStep? = {
                    let nextIndex = index + 2
                    return nextIndex < route.steps.count ? route.steps[nextIndex] : nil
                }()
                stepHeader(step: step, isFirst: index == 0, isLast: isLast, prevStep: prevStep, nextStep: nextStep, afterStep: afterStep)
                stepDetail(step: step, prevStep: prevStep, nextStep: nextStep, afterStep: afterStep)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        
    }

    @ViewBuilder
    func stepHeader(step: RouteStep, isFirst: Bool, isLast: Bool, prevStep: RouteStep?, nextStep: RouteStep?, afterStep: RouteStep?) -> some View {
        if step.type == .bus {
            EmptyView()
        } else {
            VStack(spacing: 0) {
                Spacer().frame(maxHeight: 13)
                HStack(alignment: .top, spacing: 12) {
                // LEFT COLUMN (icon + rail/labels)
                if step.type == .subway {
                    VStack(spacing: 2) {
                        stepImage(for: step)
                            .frame(width: 18, height: 20)
                        // 호선 라벨("서울 지하철"/"수도권 전철" 제거 후 표기)
                        Text(cleanedLineName(step.title))
                            .font(.mainTextSemibold12)
                        
                        let color: Color = {
                            let raw = cleanedLineName(step.title)
                            return step.subwayLine?.color ?? subwayColor(from: raw)
                        }()
                        //색깔 맞춰서 선긋기
                        Rectangle().fill(color)
                            .frame(width: 3)
                            .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                    .frame(width: 40, alignment: .center)
                } else if step.type == .walk {
                    VStack(spacing: 2) {
                        if isFirst {
                            Image("start")
                                .frame(width: 16, height: 20)
                            Text("출발")
                                .font(.mainTextSemibold12)
                                .foregroundStyle(Color.positive)
                            Image(.dot3)
                        } else if isLast {
                            Image("fin").frame(width: 18, height: 20)
                            Text("도착").font(.mainTextSemibold12).foregroundStyle(Color.error)
                        } else {
                            if prevStep?.type == .subway {
                                // Hide duplicate left marker/label/dots for walk right after subway
                                EmptyView()
                            } else if prevStep?.type == .bus {
                                // Use previous BUS color for the walk segment marker
                                let color: Color = prevStep?.busType?.color ?? .gray
                                ZStack(alignment: .center) {
                                    Image("check04")
                                        .renderingMode(.template)
                                        .foregroundStyle(color)
                                    Image("check03")
                                        .renderingMode(.original)
                                        .offset(x: -1.2, y: 2.5)
                                }
                                .frame(width: 16, height: 16)
                                // one dot under the colored marker
                                Image("dot3")
                            }
                        }
                    }
                    .frame(width: 40, alignment: .center)
                } else {
                    VStack(spacing: 2) {
                        stepImage(for: step).frame(width: 18, height: 20)
                    }
                    .frame(width: 40, alignment: .center)
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
                            Text("\(parts.first ?? baseText)")
                                .font(.mainTextSemibold14)
                             
                            let nextBase = nextStep?.subTitle ?? nextStep?.title ?? baseText
                            let nextParts: [String] = {
                                if nextBase.contains("->") { return nextBase.components(separatedBy: "->").map { $0.trimmingCharacters(in: .whitespaces) } }
                                if nextBase.contains("→") { return nextBase.components(separatedBy: "→").map { $0.trimmingCharacters(in: .whitespaces) } }
                                return [nextBase]
                            }()
                            let nextBoarding = nextParts.first ?? nextBase   // e.g., "홍대입구역"

                            let distanceText: String = {
                                if let m = step.moveCount {
                                    return "도보 \(m)m"
                                }
                                if let right = step.title.split(separator: "|").last {
                                    // title might already contain "도보 30m"
                                    return right.trimmingCharacters(in: .whitespaces)
                                }
                                return "도보"
                            }()
                            Spacer().frame(height:15)
                            HStack(spacing: 8) {
                                Text("\(nextBoarding)까지")
                                    .font(.mainTextRegular12)
                                    .fixedSize()
                                
                                Image("mini")
                                Text(distanceText)
                                    .font(.mainTextRegular12)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.85)
                                    .allowsTightening(true)
                                    .fixedSize(horizontal: true, vertical: false)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Rectangle()
                                .fill(Color("F3"))
                                .frame(height: 1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 20)
                           
                        } else if isLast {
                            Text(parts.count > 1 ? parts.last! : baseText)
                                .font(.mainTextSemibold14)
                                
                        } else {
                            if prevStep?.type == .subway || prevStep?.type == .bus {
                                // 하차 텍스트는 직전 지하철/버스 블록에서 이미 렌더링했으므로 여기서는 표시하지 않음
                                EmptyView()
                            } else {
                                Text((parts.first ?? baseText) + " 하차")
                                    .font(.mainTextSemibold12)
                                  
                            }
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
                        Spacer().frame(maxHeight:1)
                        Text(fromStation + "역 승차")
                            .font(.mainTextSemibold14)
                        //지하철 상세 정보
                        VStack(alignment: .leading, spacing: 8) {
                            Spacer().frame(maxHeight:18)
                                Text("휠체어 전용석 \(step.chair ?? "-")")
                                    .font(.mainTextSemibold12)
                                    .foregroundStyle(Color.blue700)
                                
                                Text("엘레베이터와 가까운 출구 번호 \(step.elevator ?? "-")")
                                    .font(.mainTextSemibold12)
                                    .foregroundStyle(Color.blue700)
                                
                           
                                Text("장애인 화장실 \(step.toilet ?? "X")")
                                    .font(.mainTextSemibold12)
                                    .foregroundStyle(Color.blue700)
                               
                            }
                        Spacer().frame(height:10)
                        // 승차역 토글 (5개역 이동)
                        if let stops = step.stops, !stops.isEmpty {
                            TrainStopToggleView(stops: stops)
                        }
                        Rectangle()
                            .fill(Color("F3"))
                            .frame(height: 1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 18)
                       
                        
                    }
                }
                
            }
            // 하차 밑에 ~까지
                if (step.type == .subway || step.type == .bus), let next = nextStep, next.type == .walk, !(next.title.contains("도착")) {
                let base = next.subTitle ?? next.title
                let parts: [String] = {
                    if base.contains("->") { return base.components(separatedBy: "->").map { $0.trimmingCharacters(in: .whitespaces) } }
                    if base.contains("→") { return base.components(separatedBy: "→").map { $0.trimmingCharacters(in: .whitespaces) } }
                    return [base]
                }()
                let arrivalName = parts.first ?? base
                VStack(spacing: 0) {
                    Spacer().frame(maxHeight: 13)
                    HStack(alignment: .top, spacing: 12) {
                        VStack(spacing: 2) {
                            let color: Color = {
                                let raw = cleanedLineName(step.title)
                                return step.subwayLine?.color ?? subwayColor(from: raw)
                            }()
                            Circle()
                                .fill(color)
                                .frame(width: 16, height: 16)
                            Text(cleanedLineName(step.title))
                                .font(.mainTextSemibold12)
                            Image("dot3")
                        }
                        .frame(width: 40, alignment: .center)
                        VStack(alignment: .leading, spacing: 2) {
                            Spacer().frame(maxHeight:1)
                            Text(arrivalName + "역 하차")
                                .font(.mainTextSemibold14)
                              
                           
                            let boardingBase: String = {
                                if let after = afterStep, (after.type == .subway || after.type == .bus) {
                                    var s = after.subTitle ?? after.title
                                    if s.contains("->") {
                                        s = s.components(separatedBy: "->").map { $0.trimmingCharacters(in: .whitespaces) }.first ?? s
                                    } else if s.contains("→") {
                                        s = s.components(separatedBy: "→").map { $0.trimmingCharacters(in: .whitespaces) }.first ?? s
                                    }
                                    if let pipe = s.range(of: "|") { s = String(s[..<pipe.lowerBound]).trimmingCharacters(in: .whitespaces) }
                                    s = s.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
                                    return s
                                } else if let next = nextStep {
                                    var s = next.subTitle ?? next.title
                                    if s.contains("->") {
                                        s = s.components(separatedBy: "->").map { $0.trimmingCharacters(in: .whitespaces) }.first ?? s
                                    } else if s.contains("→") {
                                        s = s.components(separatedBy: "→").map { $0.trimmingCharacters(in: .whitespaces) }.first ?? s
                                    }
                                    if let pipe = s.range(of: "|") { s = String(s[..<pipe.lowerBound]).trimmingCharacters(in: .whitespaces) }
                                    s = s.replacingOccurrences(of: "<b>", with: "").replacingOccurrences(of: "</b>", with: "")
                                    return s
                                } else {
                                    return ""
                                }
                            }()
                            let distanceText: String = {
                                if let m = next.moveCount { return "도보 \(m)m" }
                                if let right = next.title.split(separator: "|").last { return right.trimmingCharacters(in: .whitespaces) }
                                return "도보"
                            }()
                            Spacer().frame(maxHeight:17)
                            HStack(spacing: 8) {
                                Text("\(boardingBase)까지")
                                    .font(.mainTextRegular12)
                                    .fixedSize()
                                  
                                Image("mini")
                                Text(distanceText)
                                    .font(.mainTextRegular12)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.85)
                                    .allowsTightening(true)
                                    .fixedSize(horizontal: true, vertical: false)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Rectangle()
                                .fill(Color("F3"))
                                .frame(height: 1)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.top, 20)
                            
                        }
                    }
                }
            }
                }
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
    func stepDetail(step: RouteStep, prevStep: RouteStep?, nextStep: RouteStep?, afterStep: RouteStep?) -> some View {
        switch step.type {
        case .bus:
            BusStepView(step: step, nextStep: nextStep, afterStep: afterStep)
        case .subway:
            SubwayStepView(step: step)
        case .walk:
            let isTransferWalk = (prevStep?.type == .subway || prevStep?.type == .bus) && (nextStep?.type == .subway || nextStep?.type == .bus)
            let isLeadingWalk = (prevStep == nil) && (nextStep?.type == .subway || nextStep?.type == .bus)
            if isTransferWalk || isLeadingWalk {
                // 전환/출발 직후 WALK는 헤더에서 이미 안내를 렌더링했으므로 상세는 생략
                EmptyView()
            } else {
                WalkStepView(step: step)
            }
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
    let nextStep: RouteStep?
    let afterStep: RouteStep?

    // Helper function to chunk the label for bus step titles
    private func chunkedLabel(_ s: String) -> String {
        let chars = Array(s)
        // Apply only when length >= 5
        guard chars.count >= 5 else { return s }

        // 1) Prefer split immediately AFTER first 'A' or 'B' if present
        if let idx = chars.firstIndex(where: { $0 == "A" || $0 == "B" }) {
            let first = String(chars[...idx])
            let rest = (idx + 1 < chars.count) ? String(chars[(idx+1)...]) : ""
            return rest.isEmpty ? first : (first + "\n" + rest)
        }

        // 2) Fallback: 3 + rest
        let first = String(chars.prefix(3))
        let rest = String(chars.dropFirst(3))
        return first + "\n" + rest
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer().frame(maxHeight: 13)
            HStack(alignment: .top, spacing: 12) {
                // LEFT: Bus circle, number, line
                VStack(spacing: 0) {
                    let busColor: Color = step.busType?.color ?? .gray
                    ZStack(alignment: .center) {
                        Image("check04")
                            .renderingMode(.template)
                            .foregroundStyle(busColor)
                        Image("check03")
                            .renderingMode(.original)
                            .offset(x: -1.2, y: 2.5)
                    }
                    .frame(width: 16, height: 16)
                    Text(chunkedLabel(step.title))
                        .multilineTextAlignment(.center)
                        .font(.mainTextSemibold12)
                        .foregroundStyle(.black)
                        .padding(.top, 2)
                    Rectangle()
                        .fill(busColor)
                        .frame(width: 3)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                }
                .frame(width: 40, alignment: .center)

                // 버스 승차 부분
                VStack(alignment: .leading, spacing: 2) {
                    let base = step.subTitle ?? step.title
                    let parts: [String] = {
                        if base.contains("->") { return base.components(separatedBy: "->").map { $0.trimmingCharacters(in: .whitespaces) } }
                        if base.contains("→") { return base.components(separatedBy: "→").map { $0.trimmingCharacters(in: .whitespaces) } }
                        return [base]
                    }()
                    Text("\(parts.first ?? base) 승차")
                        .font(.mainTextSemibold14)
                        .foregroundStyle(Color.gray900)
                    Spacer().frame(height:14)

                    HStack(spacing: 7) {
                        if let low = step.Info {
                            Text(low)
                                .font(.mainTextSemibold12)
                                .foregroundStyle(Color.blue700)
                         
                            Image(.mini2)
                        }
                        if let busTime = step.busTime {
                            Text(busTime)
                                .font(.mainTextRegular12)
                                .foregroundStyle(Color.gray700)
                        }
                    }
                    Spacer().frame(maxHeight:14)
                    if let stops = step.stops, !stops.isEmpty {
                        HStack(spacing: 0) {
                            // 버스토글
                            BusStopToggleView(stops: stops)
                        }
                    }
                    Rectangle()
                        .fill(Color("F3"))
                        .frame(height: 1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 18)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }

            if let stops = step.stops, let lastStop = stops.last {
                Spacer().frame(maxHeight:13)
                HStack(alignment: .top, spacing: 12) {
                    VStack(spacing: 2) {
                        let busColor: Color = step.busType?.color ?? .gray
                        Circle()
                            .fill(busColor)
                            .frame(width: 16, height: 16)
                        Text(chunkedLabel(step.title))
                            .multilineTextAlignment(.center)
                            .font(.mainTextSemibold12)
                            .foregroundStyle(.black)
                            .padding(.top, 2)
                        Image("dot3")
                    }
                    .frame(width: 40, alignment: .center)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(lastStop + " 하차")
                            .font(.mainTextSemibold14)
                            .foregroundStyle(Color.gray900)

                        let boardingBase: String = {
                            // 왼쪽/오른쪽 이름 추출 헬퍼
                            func leftName(_ raw: String) -> String {
                                var s = raw
                                if let pipe = s.range(of: "|") { s = String(s[..<pipe.lowerBound]).trimmingCharacters(in: .whitespaces) }
                                if s.contains("->") {
                                    s = s.components(separatedBy: "->").map { $0.trimmingCharacters(in: .whitespaces) }.first ?? s
                                } else if s.contains("→") {
                                    s = s.components(separatedBy: "→").map { $0.trimmingCharacters(in: .whitespaces) }.first ?? s
                                }
                                return s.replacingOccurrences(of: "<b>", with: "")
                                        .replacingOccurrences(of: "</b>", with: "")
                                        .replacingOccurrences(of: "승차", with: "")
                                        .trimmingCharacters(in: .whitespaces)
                            }
                            func destName(_ raw: String) -> String {
                                var s = raw
                                if let pipe = s.range(of: "|") { s = String(s[..<pipe.lowerBound]).trimmingCharacters(in: .whitespaces) }
                                if s.contains("->") {
                                    s = s.components(separatedBy: "->").map { $0.trimmingCharacters(in: .whitespaces) }.last ?? s
                                } else if s.contains("→") {
                                    s = s.components(separatedBy: "→").map { $0.trimmingCharacters(in: .whitespaces) }.last ?? s
                                }
                                return s.replacingOccurrences(of: "<b>", with: "")
                                        .replacingOccurrences(of: "</b>", with: "")
                                        .replacingOccurrences(of: "도착", with: "")
                                        .trimmingCharacters(in: .whitespaces)
                            }

                            // 1) 다음이 WALK면: 우선 afterStep(다음 승차 지점)이 있으면 그 출발 이름 사용
                            if let next = nextStep, next.type == .walk {
                                if let after = afterStep, (after.type == .bus || after.type == .subway) {
                                    return leftName(after.subTitle ?? after.title)     // 예: "한국경제인협회"
                                }
                                // 2) afterStep이 없거나 다음 WALK가 '도착'이면 목적지 이름 사용
                                let raw = next.subTitle ?? next.title
                                if afterStep == nil || raw.contains("도착") {
                                    return destName(raw)                               // 예: "카페 아임히어"
                                }
                                // 3) 그 외엔 WALK 텍스트의 왼쪽 이름(ランド마크) 사용
                                return leftName(raw)                                   // 예: "용산e편한세상"
                            }

                            return ""
                        }()
                        let distanceText: String = {
                            if let walk = nextStep, walk.type == .walk {
                                if let m = walk.moveCount { return "도보 \(m)m" }
                                if let right = walk.title.split(separator: "|").last { return right.trimmingCharacters(in: .whitespaces) }
                                return "도보"
                            }
                            return "도보"
                        }()
                        Spacer().frame(maxHeight:15)
                        HStack(spacing: 8) {
                            Text("\(boardingBase)까지")
                                .font(.mainTextRegular12)
                                .foregroundStyle(Color.gray900)
                                .fixedSize()

                            Image("mini")
                            Text(distanceText)
                                .font(.mainTextRegular12)
                                .foregroundStyle(Color.gray900)
                                .lineLimit(1)
                                .minimumScaleFactor(0.85)
                                .allowsTightening(true)
                                .fixedSize(horizontal: true, vertical: false)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Rectangle()
                            .fill(Color("F3"))
                            .frame(height: 1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, 20)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

struct SubwayStepView: View {
    let step: RouteStep
    var body: some View { EmptyView() }
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

