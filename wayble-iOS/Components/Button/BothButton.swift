//
//  BothButton.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/17/25.
//

import SwiftUI

struct BothButton: View {
    @Binding var step: Int

    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            PreviousButton {
                if step > 0 { step -= 1 }
            }
            NextButton(title: "다음") {
                if step < 3 { step += 1 }
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.bottom, 48)
    }
}



#Preview {
    struct PreviewWrapper: View {
        @State var step = 0

        var body: some View {
            BothButton(step: $step)
        }
    }

    return PreviewWrapper()
}
