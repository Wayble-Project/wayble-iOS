import SwiftUI

struct PlaceDetailView: View {
    @Bindable private var vm: PlaceDetailViewModel
    @Binding var selectedIndex: Int
    @Binding var selectedDeparture: PlaceModel?
    @Binding var selectedArrival: PlaceModel?

    init(zone: WaybleZone,
         selectedIndex: Binding<Int>,
         selectedDeparture: Binding<PlaceModel?>,
         selectedArrival: Binding<PlaceModel?>) {
        let vm = PlaceDetailViewModel()
        vm.waybleZone = zone
        self._selectedIndex = selectedIndex
        self._selectedDeparture = selectedDeparture
        self._selectedArrival = selectedArrival
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
                        ),
                        selectedIndex: $selectedIndex,
                        selectedDeparture: $selectedDeparture,
                        selectedArrival: $selectedArrival
                    )
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



//#Preview {
//    PlaceDetailView(zone: WaybleZone(...),
//                    selectedIndex: .constant(0),
//                    selectedDeparture: .constant(nil),
//                    selectedArrival: .constant(nil))
//}
