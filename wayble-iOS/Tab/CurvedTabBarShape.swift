//
//  CurvedTabBarShape.swift
//  wayble_iOS
//
//  Created by 신민정 on 7/9/25.
//

import SwiftUI
struct CurvedTabBarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        let radius: CGFloat = 33
        let arcCenter = CGPoint(x: rect.midX, y: 0)

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: arcCenter.x - radius, y: 0))

        path.addArc(center: arcCenter,
                    radius: radius,
                    startAngle: .degrees(180),
                    endAngle: .degrees(0),
                    clockwise: true)


        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()

        return path
    }
}
#Preview {
    CurvedTabBarShape()
}
