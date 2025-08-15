import SwiftUI

struct PlaceReView: View {
    @Environment(WaybleZoneNavigationRouter.self) var router
    
    @State private var selected = "추천순"
    
    @State private var showAll: Bool = false
    
    @State private var showSortMenu: Bool = false
    
    let waybleZone: WaybleZone
    let reviews: [Review]
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading) {
                HStack(spacing: 4) {
                    Text("리뷰")
                        .font(.mainTextSemibold20)
                        .foregroundStyle(Color("gray-900"))
                        .padding(.trailing, 5)
                    Image("star")
                        .resizable()
                        .renderingMode(.template)
                        .scaledToFit()
                        .frame(width: 26, height: 26)
                        .foregroundStyle(Color("blue-500"))
                    Text("4.5")
                        .font(.mainTextSemibold20)
                        .foregroundStyle(Color("gray-900"))
                }
                .padding(.horizontal, 20)
                
                Button {
                    router.push(.wZwritingReview(PlaceIdent(id: waybleZone.id, name: waybleZone.name)))
                } label: {
                    HStack(spacing: 4) {
                        Text("리뷰 작성하기")
                            .font(.mainTextSemibold14)
                            .foregroundStyle(Color("gray-900"))
                        Image("pencil")
                    }
                    .frame(maxWidth: .infinity, minHeight: 44)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color("gray-300"), lineWidth: 1)
                    )
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)

                
                
                
                WaybleZoneDropDown( options: ["추천순", "최신순"], selection: $selected).padding(.horizontal, 25)
                    .padding(.bottom, 5)
                
                
                
                
                VStack(spacing: 17) {
                    ForEach(reviews) { review in
                        ReviewCardView(review: review)
                    }
                }
                
                
                if reviews.count > 0 && !showAll {
                    ZStack {
                        Rectangle()
                            .fill(Color("gray-100"))
                            .frame(height: 1)
                        
                        Button {
                            showAll = true
                        } label: {
                            HStack(spacing: 4) {
                                Text("더보기")
                                    .font(.mainTextSemibold14)
                                    .foregroundStyle(Color("gray-900"))
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(Color("gray-700"))
                                    .font(.system(size: 10))
                                    .frame(width: 10, height: 5)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(Color("gray-100"))
                            .clipShape(Capsule())
                        }
                        .padding(.vertical, 20)
                    }
                }
            }
            
            
        }
    }
}

#Preview {
    
    PlaceReView(waybleZone: mockWaybleZoneResponse.data,reviews: mockReviewListResponse.data)
        .withWaybleZoneRouter()
            
  /*
    PlaceReView(reviews: mockReviewListResponse.data, onWrite: {})
        .withRouter(selectedIndex: .constant(0),router: NavigationRouter())
  */
}
