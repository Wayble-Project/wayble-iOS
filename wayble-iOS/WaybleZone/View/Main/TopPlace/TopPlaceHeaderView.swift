import SwiftUI

struct TopPlaceView: View {
 //   @Environment(NavigationRouter.self) var router
    @Binding var selectedIndex: Int
    @Binding var selectedPlaceID: Int? 
    @Bindable var vm: TopPlaceViewModel
    @Namespace private var underlineNamespace
    @AppStorage("selectedDong") private var selectedDong: String = "서초동"
    private var reloadKey: String { "\(vm.selected.rawValue)|\(selectedDong)" }
    var body: some View {
        VStack(alignment: .leading) {
            Text(selectedDong)
                .font(.mainTextSemibold20)
                .foregroundStyle(Color("gray-900"))
                .padding(.horizontal, 20)
                .padding(.bottom, 18)

            HStack(spacing: 14) {
                ForEach(TopPlaceViewModel.Category.allCases) { category in
                    Button {
                        withAnimation(.easeInOut) {
                            vm.selected = category
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Text(category.rawValue)
                                .font(.mainTextSemibold14)
                                .foregroundStyle(Color("gray-900"))
                                .background(
                                    ZStack {
                                        if vm.selected == category {
                                            Capsule()
                                                .fill(Color("black"))
                                                .matchedGeometryEffect(id: "underline", in: underlineNamespace)
                                                .frame(height: 2.3)
                                                .offset(y: 5)
                                        }
                                    },
                                    alignment: .bottom
                                )
                        }
                    }
                }
            }
            .padding(.horizontal, 20)

            Divider()
                .padding(.horizontal)

            // MARK: TOP 3 카드
//            ForEach(vm.top3Zones, id: \.id) { zone in
//                TopPlaceCard(zone: zone)
//                    .padding(.horizontal, 3)
//            }
            ForEach(Array(vm.top3Zones.enumerated()), id: \.element.id) { index, zone in
                TopPlaceCard(zone: zone, rank: index + 1) // index는 0부터 시작하니 +1
                    .padding(.horizontal, 3)
                    .onTapGesture {
                       // router.push(.placeDetailView(id: zone.id))
                        selectedPlaceID = zone.id          // 상세에서 사용할 id 바인딩 세팅
                                   withAnimation { selectedIndex = 21 } // 상세 탭으로 전환
                            }
            }
            

        }
//        .task {
//            await vm.fetchTop3(for: vm.selected)
//        }
        .task(id: reloadKey) {
                    await vm.fetchTop3(for: vm.selected)
                }
    }
}

//import SwiftUI
//
//struct TopPlaceView: View {
//    @Environment(NavigationRouter.self) var router
//    let favWaybleZones: [FavoritesWaybleZone]
//    
//    enum Category: String, CaseIterable, Identifiable {
//        case favorite = "즐겨찾기 순"
//        case search = "검색순"
//        var id: Self { self }
//    }
//
//    @State private var selected: Category = .favorite
//    @Namespace private var underlineNamespace
//
//    var favoriteTop3: [FavoritesWaybleZone] {
//        Array(favWaybleZones.prefix(3))
//    }
//
//    var searchTop3: [FavoritesWaybleZone] {
//        Array(favWaybleZones.suffix(3))
//    }
//
//    var selectedTop3: [FavoritesWaybleZone] {
//        switch selected {
//        case .favorite: return favoriteTop3
//        case .search: return searchTop3
//        }
//    }
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text("효창동 주변 TOP 3")
//                .font(.mainTextSemibold20)
//                .foregroundStyle(Color("gray-900"))
//                .padding(.horizontal, 20)
//                .padding(.bottom, 18)
//
//            HStack(spacing: 14) {
//                ForEach(Category.allCases) { category in
//                    Button {
//                        withAnimation(.easeInOut) {
//                            selected = category
//                        }
//                    } label: {
//                        VStack(spacing: 4) {
//                            Text(category.rawValue)
//                                .font(.mainTextSemibold14)
//                                .foregroundStyle(Color("gray-900"))
//                                .background(
//                                    ZStack {
//                                        if selected == category {
//                                            Capsule()
//                                                .fill(Color.black)
//                                                .matchedGeometryEffect(id: "underline", in: underlineNamespace)
//                                                .frame(height: 2.3)
//                                                .offset(y: 5)
//                                        }
//                                    },
//                                    alignment: .bottom
//                                )
//                        }
//                    }
//                }
//            }
//            .padding(.horizontal, 20)
//
//            Divider()
//                .padding(.horizontal)
//
//            // MARK: TOP 3 CARD
//            ForEach(Array(selectedTop3.enumerated()), id: \.element.waybleZoneInfo.id) { index, item in
//                TopPlaceCard(zone: item.waybleZoneInfo)
//                    .padding(.horizontal, 3)
//                    .onTapGesture {
//                        router.push(.placeDetailView)
//                            }
//            }
//        }
//    }
//}
//
//
//#Preview {
//    TopPlaceView(favWaybleZones: mockFavoritesZones)
//        .withRouter()
//}
//
