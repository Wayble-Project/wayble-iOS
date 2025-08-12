//
//  BusStopToggleView .swift
//  wayble-iOS
//
//  Created by 신민정 on 8/11/25.
//

import SwiftUI
import Foundation

struct BusStopToggleView: View {
    var stops: [String]
    @State private var expanded = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 7) {
                Text("\(stops.count)개 정류장 이동")
                    .font(.mainTextRegular10)
                Button(action: {
                    withAnimation {
                        expanded.toggle()
                    }
                }) {
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(expanded ? 180 : 0))
                        .animation(.easeInOut, value: expanded)
                }
                .buttonStyle(PlainButtonStyle())
            }
            if expanded {
                VStack(alignment: .leading, spacing: 7) {
                    ForEach(stops, id: \.self) { stop in
                        Text(stop)
                            .font(.mainTextRegular10)
                            .foregroundStyle(Color("gray61"))
                    }
                }
                .padding(.top, 4)
            }
                
        }
    }
}

