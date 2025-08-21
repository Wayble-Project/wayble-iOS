import SwiftUI

struct WaybleZoneHeaderCardsView: View {
    @Binding var selectedIndex: Int
    @Environment(NavigationRouter.self) var router
        var body: some View {
            VStack(alignment: .leading, spacing: 15) {
                RegionSelectionView()
                
                NavigationStack {
                    HStack(spacing: 20) {

                        
                        CategoryCard(
                                       title: "음식점",
                                       subtitle: "누구나 편하게\n식사해요",
                                       imageName: "spoon"
                                   ) {
//                                       selectedIndex = 0
//                                       print("fdsa")
                                       router.push(.wzMainMapView)
                                   }
                        
                        CategoryCard(
                                       title: "카페",
                                       subtitle: "편하게 머물 수\n있어요",
                                       imageName: "cafePlace"
                                   ) {
//                                       selectedIndex = 0
//                                       print("fdsa")
                                       router.push(.wzMainMapView)
                                   }
                   
                        

                    }.frame(maxWidth: .infinity, alignment: .center)
                }
              
                
            }
        }
}


//MARK: 카드

struct CategoryCard: View {
    let title: String
    let subtitle: String
    let imageName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color("gray-300"), lineWidth: 1)
                    )

                VStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.mainTextSemibold16)
                            .foregroundStyle(Color("gray-900"))
                           

                        Text(subtitle)
                            .font(.mainTextRegular12)
                            .foregroundStyle(Color("gray-700"))
                            .multilineTextAlignment(.leading)
                            
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Spacer()

                    HStack {
                        Spacer()
                        Image(imageName)
                            //.resizable()
                            .scaledToFit()
                            .frame(width: 48, height: 48)
                    }
                }
                .padding(13)
            }
            .frame(width: 170, height: 146)
        }
    }
}




