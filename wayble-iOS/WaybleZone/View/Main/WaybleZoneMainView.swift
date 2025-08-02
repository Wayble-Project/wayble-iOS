import SwiftUI

struct WaybleZoneMainView: View {
    @Bindable var vm: TopPlaceViewModel
    
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

    }
}

#Preview {
    //WaybleZoneView(vm: WaybleZoneViewModel())
    WaybleZoneMainView(vm: TopPlaceViewModel()).withRouter()
}
