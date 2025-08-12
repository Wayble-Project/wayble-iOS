//
//  HeartButton.swift
//  wayble-iOS
//
//  Created by 이서현 on 8/11/25.
//

import SwiftUI

struct HeartButton: View {
    let action: () -> Void
    
    init(action: @escaping () -> Void = {}) {
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Image(.heart02)
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .padding(.horizontal, 12)
                .padding(.vertical, 15)
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color.gray300, lineWidth: 1)
                }
        }
    }
}

#Preview {
    HeartButton()
}
