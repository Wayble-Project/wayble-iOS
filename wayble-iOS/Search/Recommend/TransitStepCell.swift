//
//  TransitStepCell.swift
//  wayble-iOS
//
//  Created by 신민정 on 8/14/25.
//

import SwiftUI
import Foundation

struct TransitStepCell: View {
    let step: RouteStep
    @Binding var expanded: Bool   // false = CommonStepView, true = 상세(버스/지하철)

    var body: some View {
        AnyView(
            expanded ?
                (
                    {
                        switch step.type {
                        case .bus:
                            return AnyView(BusStepView(step: step))
                        case .subway:
                            return AnyView(SubwayStepView(step: step))
                        case .walk:
                            return AnyView(CommonStepView(step: step))
                        default:
                            return AnyView(CommonStepView(step: step))
                        }
                    }()
                )
            :
                AnyView(
                    VStack(alignment: .leading, spacing: 0) {
                        CommonStepView(step: step)
                        // 요약행 아래에 토글 뷰 배치 (있을 때만)
                        if let stops = step.stops, let cnt = step.moveCount, cnt > 0 {
                            if step.type == .bus {
                                BusStopToggleView(stops: stops)   // count 제거
                            } else if step.type == .subway {
                                TrainStopToggleView(stops: stops)
                            }                        }
                    }
                )
        )
    }



    private func badgesFor(step: RouteStep) -> [String] {
        var out: [String] = []
        if let d = step.detail { out.append(d) }    // 엘리베이터 있음
        if let b = step.extraBus { out.append(b) }  // 저상버스
        if let h = step.busTime { out.append(h) }   // 배차간격 14분
        if let info = step.Info, !info.isEmpty { out.append(info) } // 방향/노선
        return out
    }
}
