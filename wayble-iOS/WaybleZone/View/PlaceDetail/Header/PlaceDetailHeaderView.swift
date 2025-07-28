import SwiftUI

struct PlaceDetailHeaderView: View {
    let imageName = "cafeMockImage"
    let cafeName = "아임히어"
    let category = "카페"
    let rating: Double = 4.5
    let isOpen = true

    var body: some View {
        PlaceToolbar(onBack: {}, onShare: {}, onLike: {}).padding(.bottom, 8)
        
        ZStack(alignment: .top) {
            
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: 342)
                .overlay(
                    VStack(alignment: .leading, spacing: 6) {
                        Text(category)
                            .font(.mainTextSemibold14)
                            .foregroundStyle(Color("blue-200"))
                        Text(cafeName)
                            .font(.mainTextSemibold24)
                            .foregroundStyle(.white)
                    }
                        .padding(),
                    alignment: .bottomLeading
                )
                .overlay(
                    HStack(spacing: 4) {
                        Image("whiteStar")
                        Text(String(format: "%.1f", rating))
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
            FinishButton()
        }.padding(.vertical, 20)
        
        Divider()
    }
}

#Preview {
    PlaceDetailHeaderView().withRouter(selectedIndex: .constant(0))
}
