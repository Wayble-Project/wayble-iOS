import SwiftUI

struct WaybleZoneMainView: View {
   // @Bindable var vm: WaybleZoneViewModel
    
    var body: some View {
            ScrollView {
                VStack(alignment: .leading) {
                    WaybleZoneHeaderView().padding(.bottom, 34)
         
                    WaybleZoneHeaderCardsView().padding(.bottom, 59)
                    
                    TopHeaderView()

                    SavedPlacesGroupView()
                    
                    //tabView

                }
               
            }.ignoresSafeArea(edges: .top)

    }
}

#Preview {
    //WaybleZoneView(vm: WaybleZoneViewModel())
    WaybleZoneMainView()
}
