//
//  DynamicMapBox.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/27/25.
//

import SwiftUI
import Foundation

struct DynamicMapBoxView: View {
    @Environment(NavigationRouter.self) private var router
    let locationManager = LocationManager.shared
    let place: PlaceModel
    @Binding var title: String
    @Binding var roadAddress: String
    @Binding var category: String
    @Binding var selectedIndex: Int
    @Binding var selectedDeparture: PlaceModel?
    @Binding var selectedArrival: PlaceModel?


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
                       Button {
                           selectedDeparture = place
                           SearchViewModel.shared.setPlace(place, for: .departure)
                           selectedIndex = 15
                           print("🟢 Start tapped → index=\(selectedIndex)")
                       } label: {
                           StartButton() // 라벨만
                       }
                       FinishButton {
                           // 이미 출발을 선택한 적이 있으면 출발 유지 + 도착만 설정
                           if selectedDeparture != nil || SearchViewModel.shared.hasUserSetDeparture {
                               selectedArrival = place
                               selectedIndex = 15
                               print("🟢 Finish tapped with existing departure -> keep departure, set arrival")
                               return
                           }

                      
                           locationManager.requestLocation { coordinate in
                               let coordDesc = coordinate.map { "(\($0.latitude), \($0.longitude))" } ?? "nil"
                               print("✅ 위치 업데이트됨: \(coordDesc)")
                               if let coord = coordinate {
                                   Task {
                                       do {
                                           let (title, road) = try await SearchViewModel.shared.callReverseGeocodeAPI(
                                               lat: coord.latitude, lng: coord.longitude
                                           )

                                           let departure = PlaceModel(
                                               title: title,
                                               roadAddress: road,
                                               x: "\(coord.longitude)",
                                               y: "\(coord.latitude)",
                                               category: "기타"
                                           )
                                           selectedDeparture = departure
                                           selectedArrival = place
                                           selectedIndex = 15
                                           print("🟢 현재 selectedIndex: \(selectedIndex)")
                                       } catch {
                                           print("주소 가져오기 실패: \(error)")
                                       }
                                   }
                               }
                           }
                       }
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
