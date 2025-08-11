//
//  MapBoxView.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/25/25.
//

import Foundation
import SwiftUI
import CoreLocation
import Observation

struct MapBoxView: View {
    
    let place: PlaceModel
    @State private var forceNavigate = false
    @Environment(NavigationRouter.self) private var router
    @Binding var selectedIndex: Int
    @Binding var selectedDeparture: PlaceModel?
    @Binding var selectedArrival: PlaceModel?
    let locationManager = LocationManager.shared
    @State private var isNavigating = false

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
                       Text(place.title.htmlStripped)
                           .font(.mainTextSemibold20)
                           .fixedSize(horizontal: true, vertical: false) //필요한 넓이만 차지

                     Text(place.category.components(separatedBy: ">").dropFirst().joined(separator: ">"))
                         .font(.mainTextRegular12)
                         .fixedSize()
                   }
                   Text(place.roadAddress)
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

                           //  아직 출발이 없다면: 현재 위치를 출발로 자동 설정 (기존 동작)
                           locationManager.requestLocation { coordinate in
                               print("✅ 위치 업데이트됨: \(coordinate)")
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

//<b> 와 같은 html 표시 없애주기
extension String {
    var htmlStripped: String {
        self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
#Preview {
    let sample = PlaceModel(
        title: "아임히어",
        roadAddress: "서울시 용산구 백범로 326 1층",
        x: "1269650571",
        y: "375381656",
        category: "음식점>카페,디저트",
        isWaybleZone: true
    )
    return MapBoxView(
            place: sample,
            selectedIndex: .constant(0),
            selectedDeparture: .constant(nil),
            selectedArrival: .constant(nil)
        )
}
