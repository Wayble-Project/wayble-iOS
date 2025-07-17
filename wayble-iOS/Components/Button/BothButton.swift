//
//  BothButton.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/17/25.
//

import SwiftUI

struct BothButton: View {
    var body: some View {
        HStack(alignment: .center, spacing: 12) {
            PreviousButton()
            NextButton(title: "다음") {
                print("다음")
            }
        }//h
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.bottom, 48)
    }
}



#Preview {
    BothButton()
}
