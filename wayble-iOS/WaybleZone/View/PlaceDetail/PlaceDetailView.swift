import SwiftUI

struct PlaceDetailView: View {
    @Bindable private var vm: PlaceDetailViewModel

    init(zone: WaybleZone) {
        let vm = PlaceDetailViewModel()
        vm.waybleZone = zone
        self.vm = vm
    }
    
    var body: some View {
        ScrollView {
            VStack() {
                
                if let zone = vm.waybleZone {
                    PlaceDetailHeaderView(
                        waybleZone: zone,
                        place: PlaceModel(
                            title: zone.name,
                            roadAddress: zone.address,
                            x: "\(zone.longitude)",  // ← 실제 좌표
                            y: "\(zone.latitude)",
                            category: zone.category
                        )
                    )
                    PlaceInfoView(waybleZone: zone)
                    PlaceReView(reviews: vm.reviews, onWrite: {})
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

//#Preview {
  //  CafeDetailView().withRouter(selectedIndex: .constant(0))
//}
