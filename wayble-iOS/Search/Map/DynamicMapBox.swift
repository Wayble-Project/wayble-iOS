//
//  DynamicMapBox.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/27/25.
//

import SwiftUI


struct DynamicMapBoxView: View {
    let place: PlaceModel
    @Binding var title: String
    @Binding var roadAddress: String
    @Binding var category: String


    var body: some View {
       ZStack() {
            RoundedRectangle(cornerRadius: 20)
               .fill(Color.white)
                .frame(maxWidth: .infinity)
                .frame(height:150)

           VStack(alignment: .leading, spacing: 0) {
               HStack{
                   VStack(alignment: .leading, spacing: 7) {
                   HStack(alignment: .firstTextBaseline, spacing: 10) {
                       Text(title.htmlStripped)
                           .font(.mainTextSemibold20)
                           .fixedSize(horizontal: true, vertical: false) //필요한 넓이만 차지

                     Text(category.components(separatedBy: ">").dropFirst().joined(separator: ">"))
                         .font(.mainTextRegular12)
                         .fixedSize()
                   }
                   Text(roadAddress)
                       .font(.mainTextRegular12)
                       .foregroundStyle(Color("gray96"))
                       .frame(maxWidth: .infinity, alignment: .leading)

               }
                   Spacer()
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
                .padding(.leading, 65)
                
            }
            .padding(.horizontal,20)
            .padding(.top,24)
        }
       .ignoresSafeArea(edges: .bottom)
        .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
    }
}


