import SwiftUI
import Foundation

private func koCategory(_ raw: String) -> String {
    switch raw.uppercased() {
    case "CAFE": return "카페"
    case "RESTAURANT": return "음식점"
    default: return raw
    }
}

struct PlaceDetailHeaderView: View {
    let waybleZone: WaybleZone
    
    let isOpen = true
    @Environment(NavigationRouter.self) private var router
    let locationManager = LocationManager.shared
    let place: PlaceModel
    
    @Binding var selectedIndex: Int
    
    var body: some View {

        PlaceToolbar(selectedIndex: $selectedIndex, zone: waybleZone).padding(.bottom, 8)
        
        ZStack(alignment: .top) {
            //TODO:  영업 중 로직
            AsyncImage(url: URL(string: waybleZone.imageUrl ?? "")) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure(_), .empty:
                    Image("cafeMockImage")
                        .resizable()
                        .scaledToFill()
                @unknown default:
                    EmptyView()
                }
            }
            .frame(height: 342)
            .overlay(
                VStack(alignment: .leading, spacing: 6) {
                    Text(koCategory(waybleZone.category))
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
                        Text(String(format: "%.1f", waybleZone.rating!))
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
            StartButton()
            FinishButton {
                locationManager.requestLocation { coordinate in
                    if let coord = coordinate {
                        let departure = PlaceModel(
                            title: "현재 위치",
                            roadAddress: "",
                            x: "\(coord.longitude)",
                            y: "\(coord.latitude)",
                            category: "기타"
                        )
                        router.push(
                            .transportation(
                                entryType: .destination,
                                selectedArrival: place,
                                selectedDeparture: departure
                            )
                        )
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

