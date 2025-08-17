import SwiftUI
import Foundation

struct PlaceDetailHeaderView: View {
    let waybleZone: WaybleZone
    
    let isOpen = true
    @Environment(NavigationRouter.self) private var router
    let locationManager = LocationManager.shared
    let place: PlaceModel
    @Binding var selectedIndex: Int
    @Binding var selectedDeparture: PlaceModel?
    @Binding var selectedArrival: PlaceModel?

    var body: some View {

        PlaceToolbar(onBack: {}, onShare: {}).padding(.bottom, 8)
        
        ZStack(alignment: .top) {
            //TODO: AsyncImage로 변경, 영업 중 로직
            Image(waybleZone.imageUrl)
                .resizable()
                .scaledToFill()
                .frame(height: 342)
                .overlay(
                    VStack(alignment: .leading, spacing: 6) {
                        Text(waybleZone.category)
                            .font(.mainTextSemibold14)
                            .foregroundStyle(Color("blue-200"))
                        Text(waybleZone.name)
                            .font(.mainTextSemibold24)
                            .foregroundStyle(.white)
                    }
                        .padding(),
                    alignment: .bottomLeading
                )
                .overlay(
                    HStack(spacing: 4) {
                        Image("whiteStar")
                        Text(String(format: "%.1f", waybleZone.rating))
                            .font(.mainTextSemibold20)
                            .foregroundStyle(.white)
                    }
                        .padding(.vertical, 23)
                        .padding(.horizontal, 25),
                    alignment: .bottomTrailing
                )
            
            if isOpen {
                Text("영업 중")
                    .font(.mainTextSemibold14)
                    .foregroundStyle(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(Color("gray-500"), in: Capsule())
                    .padding(.top, 26)
                    .padding(.trailing, 20)
                    .frame(maxWidth: .infinity, alignment: .topTrailing)
            }
            
            }
        
        HStack(spacing:10) {
            Button {
                // 출발: 현재 place를 출발로 설정하고 길찾기 탭으로 이동
                selectedDeparture = place
                SearchViewModel.shared.setPlace(place, for: .departure)
                selectedIndex = 15
                print("🟢 Start tapped → index=\(selectedIndex)")
            } label: {
                StartButton()
            }

            FinishButton {
                // 이미 출발이 있으면 출발 유지 + 도착만 설정
                if selectedDeparture != nil || SearchViewModel.shared.hasUserSetDeparture {
                    selectedArrival = place
                    selectedIndex = 15
                    print("🟢 Finish tapped with existing departure -> keep departure, set arrival")
                    return
                }

                // 출발이 없으면: 현재 위치를 출발로 자동 설정 후 도착 설정
                locationManager.requestLocation { coordinate in
                    print("✅ 위치 업데이트됨: \(coordinate)")
                    if let coord = coordinate {
                        Task {
                            do {
                                let (title, road) = try await SearchViewModel.shared.callReverseGeocodeAPI(
                                    lat: coord.latitude,
                                    lng: coord.longitude
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
                    } else {
                        print("현재 위치 가져오기 실패")
                    }
                }
            }
        }.padding(.vertical, 20)
        
        Divider()
    }
}


/*
#Preview {
    PlaceDetailHeaderView(waybleZone: mockWaybleZoneResponse.data).withRouter(selectedIndex: .constant(0))
}
*/

