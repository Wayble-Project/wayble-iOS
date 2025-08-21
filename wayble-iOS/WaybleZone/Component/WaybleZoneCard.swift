import SwiftUI

struct WaybleZoneCard: View {
    let zone: WaybleZone
    @Binding var selectedIndex: Int
    @Binding var selectedPlaceID: Int?

    @State private var isLiked = false

    private let cornerRadius: CGFloat = 15
    private let imageHeight: CGFloat = 121

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
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

                // 하트(독립 클릭)
                Button {
                    isLiked.toggle()
                } label: {
//                    Image(isLiked ? "heart.fill" : "heart")
//                        .resizable()
//                        .scaledToFit()
//                        .frame(width: 22, height: 22)
//                        .padding(10)
//                        .background(.ultraThinMaterial, in: Circle())
                }
                .buttonStyle(.borderless) // 부모 탭과 충돌 방지
                .padding(12)
                .tint(isLiked ? Color("gray-900") : .white)
            }

            // 하단 정보
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
        .contentShape(Rectangle())  // 카드 전체 탭 영역
        .onTapGesture { openDetail() } // ← 여기서 인덱스 전환
    }

    private var facilityItems: [FacilityUtils.FacilityItem] {
        if let fac = zone.facilities {
            return FacilityUtils.cardFacilityItems(from: fac)
        } else {
            return [
                .init(icon: "chair01", label: "경사로", isAvailable: false),
                .init(icon: "door",    label: "문턱 없음", isAvailable: false),
                .init(icon: "lift",    label: "엘리베이터", isAvailable: false),
                .init(icon: "table",   label: "테이블석", isAvailable: false),
                .init(icon: "chair02", label: "장애인 화장실", isAvailable: false)
            ]
        }
    }

    private var infoText: String {
        "\(zone.facilities?.floorInfo ?? "1층") · 500m · \(zone.category)"
    }

    private func openDetail() {
        selectedPlaceID = zone.id
        withAnimation { selectedIndex = 21 }
    }
}

//import SwiftUI
//
//struct WaybleZoneCard: View {
//    let zone: WaybleZone
//    @State private var isLiked = false
//
//    private let cornerRadius: CGFloat = 15
//    private let imageHeight: CGFloat = 121
//    @State private var selectedPlaceID: Int? = nil
//    var body: some View {
//        NavigationLink {
//            // 목적지
//            PlaceDetailView(
//                vm: PlaceDetailViewModel(zoneID: zone.id),
//                selectedIndex: .constant(0), writeReviewPlace: <#Binding<PlaceIdent?>#>
//             
//                // 필요 시 실제 바인딩으로 교체
//                    
//            ) .navigationBarBackButtonHidden(true)
//        } label: {
//            // ⬇️ 카드 전체가 탭 영역이 되는 Label
//            VStack(alignment: .leading, spacing: 0) {
//                ZStack(alignment: .topTrailing) {
//                    AsyncImage(url: URL(string: zone.imageUrl ?? "")) { phase in
//                        switch phase {
//                        case .success(let image):
//                            image.resizable().scaledToFill()
//                        case .failure, .empty:
//                            Image("cafeMockImage").resizable().scaledToFill()
//                        @unknown default:
//                            Color.clear
//                        }
//                    }
//                    .frame(height: imageHeight)
//                    .frame(maxWidth: .infinity)
//                    .clipped()
//                    .clipShape(RoundedCorner(radius: cornerRadius, corners: [.topLeft, .topRight]))
//
//                    // 하트 버튼: borderless로 부모 링크 탭 전파 차단
//                    Button {
//                        isLiked.toggle()
//                        // TODO: 서버 반영
//                    } label: {
//                        Image(isLiked ? "heart.fill" : "heart") // 에셋 사용 예시
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 22, height: 22)
//                            .padding(10)
//                            .background(.ultraThinMaterial, in: Circle())
//                    }
//                    .buttonStyle(.borderless)   // 🔴 중요: 부모 NavigationLink 트리거 방지
//                    .padding(12)
//                    .tint(isLiked ? Color("gray-900") : .white)
//                }
//
//                // 하단 정보
//                VStack(alignment: .leading, spacing: 6) {
//                    HStack(alignment: .firstTextBaseline, spacing: 10) {
//                        Text(zone.name)
//                            .font(.mainTextSemibold20)
//                            .foregroundStyle(Color("gray-900"))
//                            .padding(.top, 5)
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
//                            Text(String(format: "%.1f", zone.rating ?? 5))
//                                .font(.mainTextRegular12)
//                                .foregroundStyle(Color("gray-900"))
//                        }
//                    }
//                    .padding(.horizontal, 3)
//                    .padding(.vertical, 3)
//                    .padding(.bottom, 5)
//
//                    HStack {
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
//                    }
//                    .padding(.vertical, 4)
//                }
//                .padding(.horizontal, 12)
//                .padding(.bottom, 12)
//            }
//            .background(
//                RoundedRectangle(cornerRadius: cornerRadius)
//                    .fill(.white)
//                    .stroke(Color("gray-300"), lineWidth: 1)
//            )
//            .padding(.horizontal, 20)
//            .contentShape(Rectangle()) // 카드 주변 여백 탭도 허용
//        }
//        .buttonStyle(.plain) // 라벨 내 컨트롤들 기본 버튼 스타일 영향 제거
//    }
//
//    private var facilityItems: [FacilityUtils.FacilityItem] {
//        if let fac = zone.facilities {
//            return FacilityUtils.cardFacilityItems(from: fac)
//        } else {
//            return [
//                .init(icon: "chair01", label: "경사로", isAvailable: false),
//                .init(icon: "door",    label: "문턱 없음", isAvailable: false),
//                .init(icon: "lift",    label: "엘리베이터", isAvailable: false),
//                .init(icon: "table",   label: "테이블석", isAvailable: false),
//                .init(icon: "chair02", label: "장애인 화장실", isAvailable: false)
//            ]
//        }
//    }
//
//    private var infoText: String {
//        "\(zone.facilities?.floorInfo ?? "1층") · 500m · \(zone.category)"
//    }
//}
//
//
