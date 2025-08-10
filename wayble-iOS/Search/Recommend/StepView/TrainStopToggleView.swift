//
//  TrainStopToggleView.swift
//  wayble-iOS
//
//  Created by 신민정 on 8/11/25.
//

import SwiftUI
import Foundation

struct TrainStopToggleView: View {
    var stops: [String]
    @State private var expanded: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("\(stops.count)개 역 이동")
                    .font(.mainTextRegular10)
                
                Button(action: {
                    withAnimation {
                        expanded.toggle()
                    }
                }) {
                    Image("down")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .rotationEffect(.degrees(expanded ? 180 : 0))
                        .animation(.easeInOut(duration: 0.2), value: expanded)
                }
            }
            
            
            if expanded {
                VStack(alignment: .leading, spacing: 7) {
                    ForEach(stops, id: \.self) { stop in
                        Text(stop)
                            .font(.mainTextRegular10)
                            .foregroundStyle(Color("gray61"))
                    }
                }
                .padding(.top, 7)
            }
            
        }
        .padding(.horizontal,2)
        
    }
}

#Preview {
    TrainStopToggleView(stops: ["상수역", "대흥역", "공덕역"])
}
