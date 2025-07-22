import SwiftUI

struct PlaceInfoView: View {

    struct OpeningHours: Decodable {
        let open: String
        let close: String
    }

    typealias BusinessHours = [String: OpeningHours]
    
    let mockBusinessHours: BusinessHours = [
        "monday": OpeningHours(open: "11:30", close: "22:00"),
        "tuesday": OpeningHours(open: "11:30", close: "22:00"),
        "wednesday": OpeningHours(open: "11:30", close: "22:00"),
        "thursday": OpeningHours(open: "11:30", close: "22:00"),
        "friday": OpeningHours(open: "12:00", close: "22:00"),
        "saturday": OpeningHours(open: "12:00", close: "22:00"),
        "sunday": OpeningHours(open: "12:00", close: "20:00")
    ]
    
    let items: [(icon: String, label: String)] = [
            ("chair01", "경사로"),
            ("chair02", "장애인 화장실"),
            ("table", "테이블석"),
            ("door", "문턱 없음"),
            ("1F", "1층"),
            ("elevator", "엘리베이터")
        ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            HStack(alignment: .top, spacing: 12) {
                
            }
            
            
            
            HStack(alignment: .top, spacing: 12) {
                       Image(systemName: "clock")
                           .padding(.top, 2)

                       VStack(alignment: .leading, spacing: 4) {
                           ForEach(DayUtils.dayOrder, id: \.self) { key in
                               if let hours = mockBusinessHours[key] {
                                   Text("\(DayUtils.Kday(key)) \(hours.open)~\(hours.close)")
                               }
                           }
                       }
                       .font(.subheadline)
                   }
                   .foregroundStyle(.primary)
               }

            Divider()
                .padding(.horizontal)

         
                   VStack(alignment: .leading, spacing: 12) {
                       Text("시설 정보")
                           .font(.mainTextSemibold20)
                           .foregroundStyle(Color("gray-900"))

                       // 2열 그리드 배치
                       LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                           ForEach(items, id: \.label) { item in
                               HStack(spacing: 5) {
                                   Image(item.icon)
                                       .frame(width: 24, height: 24)
                                   Text(item.label)
                               }
                           }
                       }
                       .font(.subheadline)
                       .padding(.horizontal)
                   }
               }
        
    }


#Preview {
    PlaceInfoView()
}
