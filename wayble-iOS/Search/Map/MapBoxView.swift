//
//  MapBoxView.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/25/25.
//

import SwiftUI

struct MapBoxView: View {
    let place: PlaceModel

    var body: some View {
       ZStack() {
            RoundedRectangle(cornerRadius: 20)
               .fill(Color.white)
                .frame(maxWidth: .infinity)
                .frame(height:150)

           VStack(alignment: .leading, spacing: 0) {
               HStack{
                   VStack(alignment: .leading, spacing: 7) {
                   HStack(spacing: 10) {
                       //아임히어
                       Text(place.title)
                           .font(.mainTextSemibold20)
                       
                       //카페
                       Text(place.category.components(separatedBy: ">").first ?? "")
                           .font(.mainTextRegular12)
                       
                   }
                   Text(place.roadAddress)
                       .font(.mainTextRegular12)
                       .foregroundStyle(Color("gray96"))
               }
               Spacer()
                   .frame(width:170)
                   if place.isWaybleZone ?? false {
                       Image("badge")
                   }
           }
               Spacer()
                   .frame(height:26)
               HStack {
                   HStack(spacing: 10) {
                        StartButton()
                        FinishButton()
                    }
                    Spacer()
                }
                .padding(.leading, 60)
                
            }
            .padding(.horizontal,20)
            .padding(.top,24)
        }
        .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 20
    var corners: UIRectCorner = [.topLeft, .topRight]

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
#Preview {
    let sample = PlaceModel(
        title: "아임히어",
        roadAddress: "서울시 용산구 백범로 326 1층",
        x: "1269650571",
        y: "375381656",
        category: "카페>디저트",
        isWaybleZone: true
    )
    MapBoxView(place: sample)
}
