
import SwiftUI

struct TopPlaceCard: View {
    let zone: FavWaybleZoneInfo
    let rank: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                //  Text("\(rank)")
                Text("\(rank)")
                    .font(.mainTextSemibold14)
                    .foregroundStyle(Color("gray-900"))

                let url = URL(string: zone.imageUrl ?? "")

                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .loading))
                            .frame(width: 90, height: 75)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 90, height: 75)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    case .failure:
                        Image("placeholder") // 에셋에 있는 기본 이미지
                            .resizable()
                            .scaledToFill()
                            .frame(width: 90, height: 75)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }

                
                VStack(alignment: .leading, spacing: 4) {
                    Text(zone.name)
                        .font(.mainTextSemibold16)
                        .foregroundStyle(Color("gray-900"))
                        .padding(.bottom, 7)

                    Text(infoText)
                        .font(.mainTextRegular12)
                        .foregroundStyle(Color("gray-900"))

                    HStack(spacing: 3) {
                        Image("star")
                            .resizable()
                            .frame(width: 12, height: 12)
                            .foregroundStyle(Color("gray-900"))
                         
                        Text(String(format: "%.1f", zone.rating))
                            .font(.mainTextRegular12)
                            .foregroundStyle(Color("gray-900"))
                    }
                }
                
                Spacer()
            }

            HStack(spacing: 0) {
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
        }
        .padding(.vertical, 10)
        .padding(.horizontal)
        
        if rank < 3 {
            Divider()
                .padding(.vertical, 5)
        }

    }
}

private extension TopPlaceCard {
    var facilityItems: [FacilityUtils.FacilityItem] {
            FacilityUtils.cardFacilityItems(from: zone.facilities)
        }
    
    var infoText: String {
//        "\(zone.facilities.floorInfo) · \(zone.address.components(separatedBy: " ").last ?? "") · \(zone.category)"
        
        "\(zone.facilities.floorInfo) · 500m · \(zone.category)"
    }
}

#Preview {
    TopPlaceCard(zone: mockFavoritesZones[0].waybleZoneInfo
                 ,rank: 2
    )
}
