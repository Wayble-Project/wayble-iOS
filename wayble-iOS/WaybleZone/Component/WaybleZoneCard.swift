import SwiftUI

struct WaybleZoneCard: View {
    let zone: WaybleZone

    var body: some View {
        Button(action: {
            //router
        }) {
            VStack(alignment: .leading) {
  
//                AsyncImage(url: URL(string: zone.imageUrl)) { image in
//                    image
//                        .resizable()
//                        .scaledToFill()
//                } placeholder: {
//                    Color("gray-100")
//                }
//                .frame(height: 111)
//                .clipped()
//                .cornerRadius(15, corners: [.topLeft, .topRight])
                
                Image(zone.imageUrl)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 111)
                    .clipped()
                    .cornerRadius(15, corners: [.topLeft, .topRight])
                    .padding(.bottom, 10)


                VStack(alignment: .leading, spacing: 6) {
                    HStack(alignment: .firstTextBaseline, spacing: 10) {
                        Text(zone.name)
                            .font(.mainTextSemibold22)
                            .foregroundStyle(Color("gray-900"))
                        Text(infoText)
                            .font(.mainTextRegular12)
                            .foregroundStyle(Color("gray-900"))
                        
                        Spacer()
                        HStack(spacing: 3) {
                            Image("star")
                                .resizable()
                                .frame(width: 12, height: 12)
                                .foregroundStyle(Color("gray-900"))
                             
                            Text(String(format: "%.1f", zone.rating))
                                .font(.mainTextRegular12)
                                .foregroundStyle(Color("gray-900"))
                        }
                    }.padding(.horizontal, 3)
                        .padding(.vertical, 3)
                        .padding(.bottom, 5)


                    HStack() {
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
                    }.padding(.vertical, 4)
                }
                .padding(.horizontal, 12)
                .padding(.bottom, 12)
            }
            
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(.white)
                    .stroke(Color("gray-300"), lineWidth: 1)
            )
            .padding(.horizontal, 20)
        }
        .buttonStyle(.plain)
    }

    private var facilityItems: [FacilityUtils.FacilityItem] {
        FacilityUtils.cardFacilityItems(from: zone.facilities)
    }

    private var infoText: String {
        "\(zone.facilities.floorInfo) · 500m · \(zone.category)"
    }
}
#Preview {
    WaybleZoneCard(zone: mockWaybleZoneResponse.data)
 
}
