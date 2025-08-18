//
//  RouteView.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/13/25.
//

import Foundation
import SwiftUI

struct RouteView: View {
    let route: RouteOption
    var onRouteSelected: (() -> Void)? = nil

    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading) {
                // 상단 상태 바(필요하면 확장)
                HStack {
                    Text("추천경로")
                        .font(.mainTextSemibold20)
                }
                Spacer().frame(height: 24)

                // simple == true 만 사용
                let simpleSteps = route.steps.filter { $0.simple }

                // 카드에서는 첫 도보는 숨기고, 버스/지하철 + 마지막(도착)만 노출
                let displayedIndices: [Int] = {
                    guard !simpleSteps.isEmpty else { return [] }
                    let last = simpleSteps.count - 1
                    var result: [Int] = []
                    for i in 0...last {
                        if i == last { result.append(i); continue }  // 마지막(대개 도착)은 항상 노출
                        let t = simpleSteps[i].type
                        if t == .bus || t == .subway { result.append(i) }
                    }
                    return result
                }()

                ForEach(displayedIndices, id: \.self) { i in
                    let step = simpleSteps[i]
                    let isLast = (i == displayedIndices.last)

                    HStack(alignment: .top, spacing: 12) {
                        // 왼쪽 아이콘/라인
                        VStack(spacing: 0) {
                            if isLast {
                                Image("fin")
                                    .frame(width: 16, height: 20)
                                    .padding(.bottom, 4)
                                Text("도착")
                                    .foregroundStyle(Color("error"))
                                    .font(.mainTextSemibold12)
                            } else {
                                stepImage(for: step)
                                    .padding(.bottom, 1)
                            }

                            if !isLast {
                                let displayTitle: String = {
                                    if step.type == .subway {
                                        return cleanedLineName(step.title)
                                    }
                                    return step.title
                                }()

                                Text(displayTitle)
                                    .font(.mainTextSemibold12)
                                    .foregroundColor(.black)
                                    .lineSpacing(-2)
                                    .padding(.bottom, 2)
                            }

                            if !isLast {
                                let color: Color = {
                                    switch step.type {
                                    case .subway:
                                        let raw = cleanedLineName(step.title)
                                        return step.subwayLine?.color ?? subwayColor(from: raw)
                                    case .bus:
                                        return step.busType?.color ?? .gray
                                    default:
                                        return .clear
                                    }
                                }()
                                VStack(spacing: 0) {
                                    // short cap just above the marker
                                    Rectangle()
                                        .fill(color)
                                        .frame(width: 3, height: 20)
                                    // main rail below the marker
                                    Rectangle()
                                        .fill(color)
                                        .frame(width: 3, height: 15)
                                }
                              
                            }
                        }
                        .frame(width: 46, alignment: .center)

                        // 오른쪽 정보
                        VStack(alignment: .leading, spacing: 6) {
                            VStack(alignment: .leading, spacing: 3) {
                                // 제목 라인: 버스/지하철은 좌측 텍스트만, 마지막(도착)은 오른쪽 텍스트만
                                let arrow = " → "
                                let parts = step.subTitle.components(separatedBy: arrow)
                                let leftText  = parts.first ?? step.subTitle
                                let rightText = parts.count > 1 ? parts.last! : step.subTitle

                                let mainText: String = {
                                    if isLast {
                                        return rightText // 도착지명만
                                    }
                                    switch step.type {
                                    case .bus:
                                        return leftText  // 버스는 왼쪽만
                                    case .subway:
                                        var name = cleanedLineName(leftText)
                                        if !name.hasSuffix("역") { name += "역" }
                                        return name
                                    case .walk:
                                        return step.subTitle
                                    }
                                }()

                                Text(mainText)
                                    .font(.mainTextSemibold14)
                                    .foregroundColor(.black)

                                // 보조 정보 라인
                                if !isLast {
                                    switch step.type {
                                    case .subway:
                                        HStack(spacing: 2) {
                                            Image("lift04")
                                            Text("엘리베이터 있음")
                                                .font(.mainTextSemibold12)
                                                .foregroundStyle(Color.blue700)
                                        }
                                    case .bus:
                                        HStack(spacing: 7) {
                                            if let low = step.Info  {
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
                                    case .walk:
                                        EmptyView()
                                    }
                                }
                            }

                            if step.type == .subway || step.type == .bus {
                                Rectangle().fill(Color.gray200).frame(height: 1).padding(.top, 10)
                            }
                        }
                    }
                    .padding(.trailing, 29)
                }

                Spacer().frame(height: 17)
                Rectangle() // 밑에 구분 선
                    .foregroundStyle(Color.clear)
                    .frame(height: 2)
                    .background(Color.gray300)
            }
           
            .padding(.top, 17)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            onRouteSelected?()
        }
    }

    private func cleanedLineName(_ s: String) -> String {
        var t = s
        // strip known prefixes
        if t.hasPrefix("서울지하철") || t.hasPrefix("서울 지하철") {
            t = t.replacingOccurrences(of: "서울지하철", with: "")
                 .replacingOccurrences(of: "서울 지하철", with: "")
        }
        if t.hasPrefix("수도권 전철") {
            t = t.replacingOccurrences(of: "수도권 전철", with: "")
        }
        t = t.trimmingCharacters(in: .whitespaces)
        // normalize named lines
        if t.contains("경의중앙선") { t = t.replacingOccurrences(of: "경의중앙선", with: "경의중앙") }
        return t
    }

    private func subwayColor(from name: String) -> Color {
        if let range = name.range(of: "[0-9]+(?=호선)", options: .regularExpression),
           let num = Int(name[range]), (1...9).contains(num) {
            return Color("line\(num)")
        }
        if name.contains("경의중앙") { return Color("line10") }
        return .gray
    }

    // 도착일 경우 왼쪽 이모지 "fin"으로
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

#Preview {
    let sample = RouteOption(
        totalTime: 45,
        arrivalTime: "오후 2:30 도착",
        cost: 1450,
        steps: [
            RouteStep(type: .subway, title: "6호선", subTitle: "상수역", detail: "엘리베이터 있음", extra: "14:56", Info: "응암행(광흥창역 방면)", extraBus: nil, busTime: nil, simple: true),
            RouteStep(type: .bus, title: "마포09", subTitle: "신촌오거리", detail: nil, extra: nil, Info: nil, extraBus: "저상버스", busTime: "배차간격 14분", simple: true),
            RouteStep(type: .walk, title: "도착", subTitle: "홍대정문", detail: nil, extra: nil, Info: nil, extraBus: nil, busTime: nil, simple: true)
        ]
    )
    return RouteView(route: sample)
        .environment(NavigationRouter())
}
