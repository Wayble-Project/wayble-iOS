import SwiftUI

struct TopPlaceCard: View {
    struct AccessibilityInfo: Identifiable {
        let id = UUID()
        let icon: String
        let label: String
        let isEnabled: Bool
    }

    let rank: Int = 2
    let name: String = "아임히어"
    let info: String = "1층 · 500m · 카페"
    let rating: Double = 4.5

    let accessibilityOptions: [AccessibilityInfo] = [
        .init(icon: "chair04", label: "경사로", isEnabled: true),
        .init(icon: "door", label: "문턱 없음", isEnabled: false),
        .init(icon: "lift", label: "엘리베이터", isEnabled: false),
        .init(icon: "table", label: "테이블석", isEnabled: true),
        .init(icon: "chair01", label: "장애인 화장실", isEnabled: true),
    ]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Text("\(rank)")
                    .font(.mainTextSemibold14)
                    .foregroundStyle(Color("gray-900"))

                Image("defaultPlaceImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 75)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    

                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.mainTextSemibold16)
                        .foregroundStyle(Color("gray-900"))
                        .padding(.bottom, 7)

                    Text(info)
                        .font(.mainTextRegular12)
                        .foregroundStyle(Color("gray-900"))

                    HStack(spacing: 3) {
                        Image("star")
                            .foregroundStyle(Color("gray-900"))
                         
                        Text(String(format: "%.1f", rating))
                            .font(.mainTextRegular12)
                            .foregroundStyle(Color("gray-900"))
                    }
                }

                Spacer()
            }

            HStack(spacing: 0) {
                ForEach(accessibilityOptions) { option in
                    VStack(spacing: 4) {
                        Image(option.icon)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(option.isEnabled ? Color("blue-700") : Color("gray-500"))

                        Text(option.label)
                            .font(.mainTextSemibold10)
                            .foregroundStyle(option.isEnabled ? Color("blue-700") : Color("gray-500"))
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.vertical, 10)
        //.background(Color.white)
        //.clipShape(RoundedRectangle(cornerRadius: 12))
        //.shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        .padding(.horizontal)
        
        Divider().padding(.vertical, 5)
    }
}

#Preview {
    TopPlaceCard()
}
