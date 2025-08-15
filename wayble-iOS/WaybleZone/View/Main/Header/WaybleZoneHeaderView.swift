import SwiftUI

struct WaybleZoneHeaderView: View {
    //@Environment(NavigationRouter.self) var router
    @Environment(WaybleZoneNavigationRouter.self) var router
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                HStack(spacing: 8) {
                    Image("waybleLogo3")

                    Text("wayble")
                        .font(.mainTextSemibold20)
                        .lineSpacing((20 * 1.4) - 20) // 140% line-height
                        .tracking(-0.4) // -2% of 20px = -0.4pt
                }

                Spacer()


                Button {
                    router.push(.wZSearch)
                } label: {
                    Image("search")
                        .resizable()
                        .frame(width: 24, height: 24)
                }

            }
            .padding(.top, 70)
            //.padding(.top, 44)
            .padding(.bottom, 22)
            .padding(.horizontal)

        }
        .background(Color("blue-50"))
    }
}


#Preview {
    //WaybleZoneHeaderView().withRouter(selectedIndex: .constant(0))
    WaybleZoneHeaderView().withWaybleZoneRouter()
}

