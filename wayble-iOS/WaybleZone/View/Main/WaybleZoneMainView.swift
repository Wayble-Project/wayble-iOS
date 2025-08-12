import SwiftUI

struct WaybleZoneMainView: View {
    @Bindable var vm: TopPlaceViewModel
    @Environment(WaybleZoneNavigationRouter.self) var router
   // @AppStorage("selectedDong") private var selectedDong: String = "효창동"
    
    var body: some View {
            ScrollView {
                VStack(alignment: .leading) {
                    WaybleZoneHeaderView().padding(.bottom, 34)
         
                    WaybleZoneHeaderCardsView().padding(.bottom, 59)
                    

                    TopPlaceView(vm: TopPlaceViewModel())
                    
                    //TopPlaceView(favWaybleZones: mockFavoritesZones)

                    SavedPlacesGroupView(collections: mockSavedPlaces)
                    
                    
                   // CustomTabBarView(selectedIndex: .constant(1))

                }
               
            }.ignoresSafeArea(edges: .top)
            .contentMargins(.bottom, 180, for: .scrollContent)
//            .task(id: selectedDong) {
//                        await vm.refresh(district: selectedDong)
//                    }

    }
}

#Preview {
    //WaybleZoneView(vm: WaybleZoneViewModel())
    //WaybleZoneMainView(vm: TopPlaceViewModel()).withRouter(selectedIndex: .constant(0))
    WaybleZoneMainView(vm: TopPlaceViewModel()).withWaybleZoneRouter()
}
