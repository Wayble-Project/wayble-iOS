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
    
    var apiParam: String {
        switch self {
        case .elevator:
            return "ELEVATOR"
        case .ramp:
            return "RAMP"
        case .toilet:
            return "TOILET"
        case .wheelchairCharge:
            return "WHEELCHAIR_CHARGE"
        }
    }
}

//MARK: - 엘리베이터 / 경사로 / 장애인 화장실 / 휠체어 충전소 H 스크롤 뷰
struct TopConvenientBar: View {
    var onSelect: (Convenient) -> Void = { _ in }
    /// (Convenient 매개변수) -> 어떤 버튼이 선택됐는지 전달
    /// { _ in } 부분은 기본값
    /// 아무 동작도 하지 않는 빈 클로저 삽입
    ///  -> 상위에서 콜백을 안 넘겨도 컴파일 에러 X
    
    
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
                        DispatchQueue.main.async { ///0814
                            onSelect(kind)
                        }
                        ///버튼을 눌렀을 때, kind(현재 누른 버튼의 Convenient 값)를 외부에 전달함
                        /// 버튼 누를 때마다 onSelect(kind)가 호출 -> 상위 뷰에서 API 호출이나 상태 변경 같은 로직을 실행할 수 있음
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

/// var onSelect... → 외부에서 버튼 클릭 시 실행할 행동을 넘겨받는 통로
/// onSelect(kind) → 그 통로로 지금 선택한 버튼 정보를 보내는 호출
