//
//  WalkBox.swift
//  wayble-iOS
//
//  Created by 신민정 on 8/1/25.
//

import SwiftUI

struct WalkBox: View {
    let route: RouteData
    let onTap: () -> Void
    @Binding var isSelected: Bool

    var body: some View {
        Button(action: {
            onTap()
        }) {
            VStack(alignment: .leading, spacing: 0) {
                Text(route.title)
                    .font(.mainTextRegular12)
                    .foregroundStyle(isSelected ? Color("blue-900") : Color.black)
                Spacer().frame(height: 4)

                Text(route.time)
                    .font(.mainTextSemibold20)
                    .foregroundStyle(isSelected ? Color("blue-900") : Color.black)
                Spacer().frame(height: 10)

                HStack(spacing: 4) {
                    Text(route.arrivalTime)
                    Image(.bar6)
                    Text(route.distance)
                }
                .font(.mainTextSemibold12)
                .foregroundStyle(Color("gray96"))
            }
            .padding(.trailing, 15)
            .padding(.top, 17)
            .padding(.bottom, 15)
            .frame(maxWidth: 170, maxHeight: 113)
            .background(isSelected ? Color.blue50 : Color.white)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(isSelected ? Color.blue500 : Color.gray200)
            )
        }
        .buttonStyle(.plain)
    }
}

