import SwiftUI

struct PlaceInfoView: View {
    let waybleZone: WaybleZone
    
    var body: some View {
        VStack(alignment: .leading){
            
            VStack(alignment: .leading, spacing: 24) {
                
                HStack(spacing: 6) {
                    Image("marker")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Text(waybleZone.address)
                        .font(.mainTextRegular14)
                        .foregroundStyle(Color("gray-900"))
                }
                
                
                HStack(alignment:.top, spacing: 6) {
                    Image("clock")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        ForEach(businessHourDisplay, id: \.label) { item in
                            Text("\(item.label) \(item.hours.open)~\(item.hours.close)")
                        }
                    }
                    .font(.mainTextRegular14)
                    .foregroundStyle(Color("gray-900"))
                }
                
                HStack(spacing: 6) {
                    Image("phoneCall")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                    
                    Text(waybleZone.contactNumber)
                        .font(.mainTextRegular14)
                        .foregroundStyle(Color("gray-900"))
                }
                
            }.padding(.horizontal, 20)
                .padding(.top, 20)
            
            Color("gray-100")
                .frame(height: 10)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 30)
            
            
            VStack(alignment: .leading, spacing: 18) {
                Text("시설 정보")
                    .font(.mainTextSemibold20)
                    .foregroundStyle(Color("gray-900"))
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                    ForEach(facilityItems, id: \.label) { item in
                        HStack(spacing: 5) {
                            Image(item.icon)
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .frame(width: 22, height: 22)
                                .foregroundStyle(item.isAvailable ? Color("gray-900") : Color("gray-500"))
                            Text(item.label)
                                .font(.mainTextSemibold14)
                                .foregroundStyle(item.isAvailable ? Color("gray-900") : Color("gray-500"))
                        }.frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                
            }.padding(.horizontal, 20)
            
            
            Color("gray-100")
                .frame(height: 10)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 35)
        }
    }
}

private extension PlaceInfoView {
    var businessHourDisplay: [(label: String, hours: OpeningHours)] {
        DayUtils.BusinessHourDisplay(from: waybleZone.businessHours)
    }
    
    var facilityItems: [FacilityUtils.FacilityItem] {
        FacilityUtils.makeFacilityItems(from: waybleZone.facilities)
    }
}


#Preview {
    PlaceInfoView(waybleZone: mockWaybleZoneResponse.data)
}
