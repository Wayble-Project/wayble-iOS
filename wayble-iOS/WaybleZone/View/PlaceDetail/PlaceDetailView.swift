import SwiftUI

struct CafeDetailView: View {

    var body: some View {
        ScrollView {
            VStack() {
               PlaceDetailHeaderView()
               PlaceInfoView()
                //PlaceReView()
                
             

            }
        }
        
    }
}

#Preview {
    CafeDetailView().withRouter(selectedIndex: .constant(0))
}
