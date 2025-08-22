//
//  PreviousButton.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/12/25.
//

import SwiftUI

struct PreviousButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("이전")
                .font(.mainTextSemibold14)
                .tracking(-0.28)
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .foregroundStyle(Color("gray-700"))
                .frame(maxWidth: .infinity)
                .frame(height: 50, alignment: .center)
                .background(Color("gray-200"))
                .clipShape(RoundedRectangle(cornerRadius: 13))
            
        }
    }
}



#Preview {
    PreviousButton(action: { print("이전") })
}
