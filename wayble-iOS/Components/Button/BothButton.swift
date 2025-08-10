//
//  BothButton.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/17/25.
//

import SwiftUI

struct BothButton: View {
    @Binding var step: Int
    @Binding var selectedIndex: Int
    
    @Environment(NavigationRouter.self) private var router
    var isNextDisabled: Bool = true
    var onPreviousAction: (() -> Void)? = nil // 이전 버튼 액션
    var onNextAction: (() -> Void)? = nil // 다음 버튼 액션

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            PreviousButton {
                onPreviousAction?()
                if step > 0 { step -= 1 }
            }
            NextButton(title: "다음", isDisabled: isNextDisabled) {
                onNextAction?()
                if step == 4 {
                    selectedIndex = 12
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.bottom, 48)
    }
}

/*
 if step < 3 {
     step += 1
 } else if step == 3 {
     selectedIndex = 12
 }
 */
