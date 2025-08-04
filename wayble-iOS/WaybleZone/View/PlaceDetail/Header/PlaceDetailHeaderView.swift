import SwiftUI

struct PlaceDetailHeaderView: View {
    let waybleZone: WaybleZone
    
    let isOpen = true

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
            StartButton()
            FinishButton()
        }.padding(.vertical, 20)
        
        Divider()
    }
}

/*
#Preview {
    PlaceDetailHeaderView().withRouter(selectedIndex: .constant(0))
}
*/
