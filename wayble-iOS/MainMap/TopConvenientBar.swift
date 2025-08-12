//
//  TopConvenientBar.swift
//  wayble-iOS
//
//  Created by 이서현 on 8/11/25.
//

import SwiftUI

enum Convenient: String, CaseIterable, Identifiable, Hashable {
    case elevator = "엘리베이터"
    case ramp = "경사로"
    case toilet = "장애인 화장실"
    case wheelchairCharge = "휠체어 충전소"
    
    var id: String { rawValue }
    
    var icon: String {
            switch self {
            case .ramp: ///경사로
                return "chair01"
            case .toilet:
                return "chair02"
            case .elevator:
                return "elevator"
            case .wheelchairCharge:
                return "battery"
            }
        }
}

//MARK: - 엘리베이터 / 경사로 / 장애인 화장실 / 휠체어 충전소 H 스크롤 뷰
struct TopConvenientBar: View {
    @State private var selected: Convenient? = nil
    private let rows = [GridItem(.flexible())]
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHGrid(rows: rows, spacing: 10) {
                ForEach(Convenient.allCases) { kind in
                    ConvenientButton(
                        title: kind.rawValue,
                        icon: kind.icon,
                        isSelected: selected == kind
                    ){
                        selected = kind
                    }
                }
            }
        }
        .frame(height: 30)
    }
    
}

#Preview {
    TopConvenientBar()
}
