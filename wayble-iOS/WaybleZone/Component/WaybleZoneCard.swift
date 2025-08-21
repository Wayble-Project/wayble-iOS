//import SwiftUI
//
//struct WaybleZoneCard: View {
//    let zone: WaybleZone
//    @Environment(NavigationRouter.self) var router
//    var body: some View {
//        Button(action: {
//            router.push(.placeDetailView(id: zone.id))
//        }) {
//            VStack(alignment: .leading) {
//  
//                AsyncImage(url: URL(string: zone.imageUrl ?? "")) { phase in
//                    switch phase {
//                    case .success(let image):
//                        image
//                            .resizable()
//                            .scaledToFill()
//                    case .failure(_), .empty:
//                        Image("cafeMockImage")
//                            .resizable()
//                            .scaledToFill()
//                    @unknown default:
//                        EmptyView()
//                    }
//                }
//                .frame(height: 120) // 이미지 높이를 줄임 (예: 120px)
//                .clipped()
//                .cornerRadius(15, corners: [.topLeft, .topRight]) // 위쪽만 둥글게
//             
//
//                
////                Image(zone.imageUrl)
////                    .resizable()
////                    .scaledToFill()
////                    .frame(height: 111)
////                    .clipped()
////                    .cornerRadius(15, corners: [.topLeft, .topRight])
////                    .padding(.bottom, 10)
//
//
//                VStack(alignment: .leading, spacing: 6) {
//                    HStack(alignment: .firstTextBaseline, spacing: 10) {
//                        Text(zone.name)
//                            .font(.mainTextSemibold22)
//                            .foregroundStyle(Color("gray-900"))
//                        Text(infoText)
//                            .font(.mainTextRegular12)
//                            .foregroundStyle(Color("gray-900"))
//                        
//                        Spacer()
//                        HStack(spacing: 3) {
//                            Image("star")
//                                .resizable()
//                                .frame(width: 12, height: 12)
//                                .foregroundStyle(Color("gray-900"))
//                             
//                            Text(String(format: "%.1f", zone.rating!))
//                                .font(.mainTextRegular12)
//                                .foregroundStyle(Color("gray-900"))
//                        }
//                    }.padding(.horizontal, 3)
//                        .padding(.vertical, 3)
//                        .padding(.bottom, 5)
//
//
//                    HStack() {
//                        ForEach(facilityItems, id: \.label) { item in
//                            VStack(spacing: 4) {
//                                Image(item.icon)
//                                    .resizable()
//                                    .renderingMode(.template)
//                                    .frame(width: 24, height: 24)
//                                    .foregroundStyle(item.isAvailable ? Color("blue-700") : Color("gray-500"))
//                                Text(item.label)
//                                    .font(.mainTextSemibold10)
//                                    .foregroundStyle(item.isAvailable ? Color("blue-700") : Color("gray-500"))
//                            }
//                            .frame(maxWidth: .infinity)
//                        }
//                    }.padding(.vertical, 4)
//                }
//                .padding(.horizontal, 12)
//                .padding(.bottom, 12)
//            }
//            
//            .background(
//                RoundedRectangle(cornerRadius: 15)
//                    .fill(.white)
//                    .stroke(Color("gray-300"), lineWidth: 1)
//            )
//            .padding(.horizontal, 20)
//        }
//        .buttonStyle(.plain)
//    }
//
//    private var facilityItems: [FacilityUtils.FacilityItem] {
//        if let fac = zone.facilities {
//            // 서버 데이터가 있을 때: 실제 값으로 표시
//            return FacilityUtils.cardFacilityItems(from: fac)
//        } else {
//            // 서버 데이터가 없을 때: 모든 아이콘을 비활성(회색)으로 표시
//            return [
//                FacilityUtils.FacilityItem(icon: "chair01", label: "경사로", isAvailable: false),
//                FacilityUtils.FacilityItem(icon: "door", label: "문턱 없음", isAvailable: false),
//                FacilityUtils.FacilityItem(icon: "lift", label: "엘리베이터", isAvailable: false),
//              
//                FacilityUtils.FacilityItem(icon: "table", label: "테이블석", isAvailable: false),
//            
//                FacilityUtils.FacilityItem(icon: "chair02", label: "장애인 화장실", isAvailable: false)
//            ]
//        }
//    }
//
//
//    private var infoText: String {
//        "\(zone.facilities?.floorInfo ?? "1층") · 500m · \(zone.category)"
//    }
//}
//#Preview {
//    WaybleZoneCard(zone: mockWaybleZoneResponse.data)
// 
//}
import SwiftUI

struct WaybleZoneCard: View {

    @Environment(NavigationRouter.self) var router

    let zone: WaybleZone
    @State private var isLiked: Bool = false

    private let cornerRadius: CGFloat = 15
    private let imageHeight: CGFloat = 121

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {

            // 이미지 + 우측 상단 하트
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: zone.imageUrl ?? "")) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable().scaledToFill()
                    case .failure, .empty:
                        Image("cafeMockImage").resizable().scaledToFill()
                    @unknown default:
                        Color.clear
                    }
                }
                .frame(height: imageHeight)
                .frame(maxWidth: .infinity)
                .clipped()
                .clipShape(RoundedCorner(radius: cornerRadius, corners: [.topLeft, .topRight]))
                .contentShape(Rectangle())                 // 탭 영역을 전체로
                .onTapGesture { openDetail() }             // ← 사진 탭 시 이동

                // 우측 상단 하트 버튼 (독립적으로 클릭)
                Button {
                    isLiked.toggle()
                    // TODO: 서버에 좋아요 상태 반영
                } label: {
//                    Image(systemName: isLiked ? "heart.fill" : "heart")
//                        .imageScale(.large)
//                        .padding(10)
                        //.background(.ultraThinMaterial, in: Circle())
                }
                .padding(12)
                .tint(isLiked ? Color("gray-900") : Color(.white))
                .accessibilityLabel(isLiked ? "좋아요 취소" : "좋아요")
            }

            // 하단 정보 영역
            VStack(alignment: .leading, spacing: 6) {
                HStack(alignment: .firstTextBaseline, spacing: 10) {
                    Text(zone.name)
                        .font(.mainTextSemibold20)
                        .foregroundStyle(Color("gray-900"))
                        .padding(.top, 5)
                    Text(infoText)
                        .font(.mainTextRegular12)
                        .foregroundStyle(Color("gray-900"))

                    Spacer()
                    HStack(spacing: 3) {
                        Image("star")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(Color("gray-900"))
                        Text(String(format: "%.1f", zone.rating ?? 5))
                            .font(.mainTextRegular12)
                            .foregroundStyle(Color("gray-900"))
                    }
                }
                .padding(.horizontal, 3)
                .padding(.vertical, 3)
                .padding(.bottom, 5)

                HStack {
                    ForEach(facilityItems, id: \.label) { item in
                        VStack(spacing: 4) {
                            Image(item.icon)
                                .resizable()
                                .renderingMode(.template)
                                .frame(width: 24, height: 24)
                                .foregroundStyle(item.isAvailable ? Color("blue-700") : Color("gray-500"))
                            Text(item.label)
                                .font(.mainTextSemibold10)
                                .foregroundStyle(item.isAvailable ? Color("blue-700") : Color("gray-500"))
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.vertical, 4)
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 12)
        }
        .background(
            RoundedRectangle(cornerRadius: cornerRadius)
                .fill(.white)
                .stroke(Color("gray-300"), lineWidth: 1)
        )
        .padding(.horizontal, 20)
        .onTapGesture { openDetail() }   // 카드 아무 곳이나 탭해도 이동
    }

        private var facilityItems: [FacilityUtils.FacilityItem] {
            if let fac = zone.facilities {
                // 서버 데이터가 있을 때: 실제 값으로 표시
                return FacilityUtils.cardFacilityItems(from: fac)
            } else {
                // 서버 데이터가 없을 때: 모든 아이콘을 비활성(회색)으로 표시
                return [
                    FacilityUtils.FacilityItem(icon: "chair01", label: "경사로", isAvailable: false),
                    FacilityUtils.FacilityItem(icon: "door", label: "문턱 없음", isAvailable: false),
                    FacilityUtils.FacilityItem(icon: "lift", label: "엘리베이터", isAvailable: false),
    
                    FacilityUtils.FacilityItem(icon: "table", label: "테이블석", isAvailable: false),
    
                    FacilityUtils.FacilityItem(icon: "chair02", label: "장애인 화장실", isAvailable: false)
                ]
            }
        }
    
    
        private var infoText: String {
            "\(zone.facilities?.floorInfo ?? "1층") · 500m · \(zone.category)"
        }

    private func openDetail() {
        // router.push(.placeDetail( ... )) 등 실제 라우팅 넣기
        // print("Go to detail:", zone.name)
        router.push(.placeDetailView(id: zone.id))
    }
}

// 특정 모서리만 둥글게

