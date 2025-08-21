import SwiftUI

struct WaybleZoneMainView: View {
    @Bindable var vm: TopPlaceViewModel
    @Environment(NavigationRouter.self) var router
    @Binding var selectedIndex: Int
    //@Environment(WaybleZoneNavigationRouter.self) var router
   // @AppStorage("selectedDong") private var selectedDong: String = "효창동"
    
    var body: some View {
            ScrollView {
                VStack(alignment: .leading) {

                    WaybleZoneHeaderView().padding(.bottom, 34)
         
                    WaybleZoneHeaderCardsView(selectedIndex: $selectedIndex).padding(.bottom, 59)
                    

                    TopPlaceView(vm: TopPlaceViewModel())
                    
  
                    SavedPlacesGroupView(vm: UserPlaceViewModel(), selectedIndex: $selectedIndex)
                    

                }
               
            }.ignoresSafeArea(edges: .top)
            .contentMargins(.bottom, 180, for: .scrollContent)
        //            .task(id: selectedDong) {
//                        await vm.refresh(district: selectedDong)
//                    }

    }
}

