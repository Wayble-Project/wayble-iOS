//import SwiftUI
//
//struct SavedPlaceListCardView: View {
//
//    //let places: [WaybleZone]
//    //let collections: [SavedPlace]
//    let place: SimpleSavedPlaceResponse
//
////        var Zone: WaybleZone? {
////            collections.first?.waybleZone
////        }
//    
//    var body: some View {
//        VStack() {
//            HStack() {
//                BackButton()
//                    .padding(.trailing, 5)
//                
//                Text("내가 저장한 장소")
//                    .font(.mainTextSemibold20)
//                    .foregroundStyle(Color("gray-900"))
//                
//                Spacer()
//            }
//            .padding(.horizontal, 20)
//
//
//            HStack(spacing: 12) {
//                Image("Place\(place.color)")
//                    .resizable()
//                    .frame(width: 36, height: 36)
//                    .clipShape(Circle())
//
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(place.title)
//                        .font(.mainTextSemibold16)
//                        .foregroundStyle(Color("gray-900"))
//
//                    Text("저장 장소 20")
//                        .font(.mainTextRegular12)
//                        .foregroundStyle(Color("gray-700"))
//                }
//
//                Spacer()
//
//                Image(systemName: "chevron.up")
//                    .foregroundStyle(Color("gray-500"))
//            }
//            .padding(.horizontal, 20)
//            .padding(.top, 16)
//            .padding(.bottom, 4)
//
//            
//            // MARK: CARD
//            ScrollView {
//                VStack(spacing: 30) {
//                    ForEach(place.waybleZone) { zone in
//                        WaybleZoneCard(zone: zone)
//                            
//                    }
//                }
//                .padding(.top, 10)
//            }
//        }
//    }
//}
//
//
//#Preview {
//    SavedPlaceListCardView(place: mockSavedPlaces[0]).withRouter(selectedIndex: .constant(0))
//}
import SwiftUI

struct SavedPlaceListCardView: View {
    @Environment(NavigationRouter.self) var router
    @Binding var selectedIndex: Int
    let place: SimpleSavedPlaceResponse
    @State private var _vm = UserPlaceViewModel()

    var body: some View {
        @Bindable var vm = _vm
        
        VStack {
            HStack {
                WZBackButton(selectedIndex: $selectedIndex, toTab: 4)
                    .padding(.trailing, 5)

                Text("내가 저장한 장소")
                    .font(.mainTextSemibold20)
                    .foregroundStyle(Color("gray-900"))

                Spacer()
            }
            .padding(.horizontal, 20)

            
            HStack(spacing: 12) {
                Image("Place\(place.color)")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 4) {
                    Text(place.title)
                        .font(.mainTextSemibold16)
                        .foregroundStyle(Color("gray-900"))

                    Text("저장 장소 \(place.savedCount)")
                        .font(.mainTextRegular12)
                        .foregroundStyle(Color("gray-700"))
                }

                Spacer()

                Image(systemName: "chevron.up")
                    .foregroundStyle(Color("gray-500"))
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 4)

            // MARK: WaybleZoneCard
            ScrollView {
                LazyVStack(spacing: 30) {
                    ForEach(vm.zones) { zone in
                        WaybleZoneCard(zone: zone)
                    }
                }
                .padding(.top, 10)
            }
//            .refreshable {
//                await vm.loadZones(placeId: place.placeId)
//            }
        }
        .navigationBarBackButtonHidden(true)
        .task(id: place.placeId) {
            await vm.loadZones(placeId: place.placeId)
            print("zones.count =", vm.zones.count)
        }
    }
}

//
//#Preview {
//  
//    let sample = SimpleSavedPlaceResponse(
//        placeId: 1,
//        title: "강남 카페 리스트",
//        color: "Blue",
//        savedCount: 20
//    )
//    return SavedPlaceListCardView(place: sample)
//        .environment(NavigationRouter())
//}

