import SwiftUI

struct PlaceDetailView: View {
    @Bindable private var vm = PlaceDetailViewModel()
    
    var body: some View {
        ScrollView {
            VStack() {
                
                if let zone = vm.waybleZone {
                    PlaceDetailHeaderView(waybleZone: zone)
                    PlaceInfoView(waybleZone: zone)
                    PlaceReView(reviews: vm.reviews)
                } else {
                    ProgressView("정보를 불러오는 중...")
                }
                
            }
        }
        .task {
            await vm.fetchPlaceDetail()
            if let zone = vm.waybleZone {
                await vm.fetchReviews(zoneID: zone.id)
            }
            
        }
    }
}

/*
#Preview {
    PlaceDetailView().withRouter(selectedIndex: .constant(0))
}
*/
