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
    @StateObject private var viewModel = MapBoxViewModel() //0818 MapBoxViewModel과 연결
    @State private var showBadge = false //0818
    @State private var forceNavigate = false
    @Environment(NavigationRouter.self) private var router
    @Binding var selectedIndex: Int
    @Binding var selectedDeparture: PlaceModel?
    @Binding var selectedArrival: PlaceModel?
    let locationManager = LocationManager.shared
    @State private var isNavigating = false

    // 선택한 장소의 위도/경도/zoneName 전달용 콜백 (필요 시 상위에서 API 호출)
    var onPlaceSelected: ((Double, Double, String) -> Void)? = nil

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
                   if showBadge { ///MapBoxViewModel의 hasWaybleBadge 리턴값이 Bool 타입. true일 때만 뱃지 생성
                       Image("badge")
                   }
           }
               Spacer()
                   .frame(height:26)
               
               HStack(spacing: 12) {
                   Button {
                       selectedDeparture = place
                       SearchViewModel.shared.setPlace(place, for: .departure)
                       selectedIndex = 15
                       print("🟢 Start tapped → index=\(selectedIndex)")
                   } label: {
                       StartButton()
                   }
                   
                   FinishButton {
                       // 이미 출발을 선택한 적이 있으면 출발 유지 + 도착만 설정
                       if selectedDeparture != nil || SearchViewModel.shared.hasUserSetDeparture {
                           selectedArrival = place
                           selectedIndex = 15
                           print("🟢 Finish tapped with existing departure -> keep departure, set arrival")
                           return
                       }
                       
                       // 아직 출발이 없다면: 현재 위치를 출발로 자동 설정
                       locationManager.requestLocation { coordinate in
                           print("✅ 위치 업데이트됨: \(String(describing: coordinate))")
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
               .frame(maxWidth: .infinity, alignment: .center) // ✅ 항상 가운데 정렬
                
            }
            .padding(.horizontal,20)
            .padding(.top,24)
        }
       .ignoresSafeArea(edges: .bottom)
        .clipShape(RoundedCorner(radius: 20, corners: [.topLeft, .topRight]))
        
        //MARK: - 웨이블존 검증 api -> 뱃지 달기
       .task {
           ///1.    MapBoxView가 화면에 나타나면 (.task)
           ///2.    서버에 뱃지 정보 요청을 보냄 (await hasWaybleBadge())
           ///3.    응답 결과가 true면 showBadge = true → 뱃지 이미지 보이게 함
           if let (lat, lng) = extractLatLng(from: place) {
               // 상위로도 필요한 파라미터 콜백 전달 (선택)
               onPlaceSelected?(lat, lng, place.title.htmlStripped)
               showBadge = await viewModel.hasWaybleBadge(
                   latitude: lat,
                   longitude: lng,
                   zoneName: place.title.htmlStripped
               )
           } else {
               print("⚠️ 좌표 변환 실패: x=\(place.x ?? "nil"), y=\(place.y ?? "nil")")
               // 실패 시 0,0 대신 배지 요청을 생략
               showBadge = false
           }
       }
    }
}

    /// Naver Local API의 x/y(문자열, 1e7 스케일)를 위경도로 변환
    /// - Returns: (lat, lng) 또는 변환 실패 시 nil
    private func extractLatLng(from place: PlaceModel) -> (Double, Double)? {
        guard
            let xStr = place.x, let yStr = place.y,
            let xVal = Double(xStr), let yVal = Double(yStr)
        else {
            return nil
        }
        // 예: x="1269650571" -> 126.9650571 (lng), y="375381656" -> 37.5381656 (lat)
        let lng = xVal / 1e7
        let lat = yVal / 1e7
        return (lat, lng)
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
