//
//  OnboardingBar.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/16/25.
//

import SwiftUI

import SwiftUI

struct OnboardingBar: View {
    @Binding var currentStep: Int
    private let totalSteps = 4
    
    var body: some View {
        HStack(spacing: 7.45) {
            ForEach(0..<totalSteps, id: \.self) { index in
                Capsule()
                    .fill(index <= currentStep ? Color("blue-500") : Color("gray-200"))
                    .frame(height: 5)
                    .frame(maxWidth: .infinity)
                    .animation(.easeInOut, value: currentStep)
            }
        }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var step = 1

        var body: some View {
            OnboardingBar(currentStep: $step)
        }
    }

    return PreviewWrapper()
}
