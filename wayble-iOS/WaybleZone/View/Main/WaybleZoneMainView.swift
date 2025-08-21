import SwiftUI

struct WaybleZoneMainView: View {
    @Bindable var vm: TopPlaceViewModel
    @Environment(NavigationRouter.self) var router
    @Binding var selectedIndex: Int
    //@Environment(WaybleZoneNavigationRouter.self) var router
   // @AppStorage("selectedDong") private var selectedDong: String = "효창동"
    //@State private var selectedSavedPlace: SimpleSavedPlaceResponse? = nil
    @Binding var selectedSavedPlace: SimpleSavedPlaceResponse?
    @Binding var selectedPlaceID: Int?
    
    var body: some View {
            ScrollView {
                VStack(alignment: .leading) {

                    WaybleZoneHeaderView(selectedIndex: $selectedIndex).padding(.bottom, 34)
         
                    WaybleZoneHeaderCardsView(selectedIndex: $selectedIndex).padding(.bottom, 59)
                    

                    TopPlaceView(selectedIndex: $selectedIndex, selectedPlaceID: $selectedPlaceID, vm: TopPlaceViewModel())
                    
  
                    SavedPlacesGroupView(vm: UserPlaceViewModel(), selectedIndex: $selectedIndex,  selectedSavedPlace: $selectedSavedPlace
                                        )
                    

                }
               
            }.ignoresSafeArea(edges: .top)
            .contentMargins(.bottom, 180, for: .scrollContent)
        //            .task(id: selectedDong) {
//                        await vm.refresh(district: selectedDong)
//                    }

    }
}

