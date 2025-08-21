import SwiftUI


struct SavedPlaceListView: View {
    @Environment(NavigationRouter.self) var router
    @State private var selected = "최신순"
    @State var vm: UserPlaceViewModel
    @Binding var selectedIndex: Int
   
   // init(vm: UserPlaceViewModel) { _vm = State(initialValue: vm) }

    var body: some View {
        VStack(alignment: .leading) {
       
            HStack {
                WZBackButton(selectedIndex: $selectedIndex, toTab: 4).padding(.trailing, 5)
                Text("내가 저장한 장소")
                    .font(.mainTextSemibold20)
                    .foregroundStyle(Color("gray-900"))
                Spacer()
            }
            .padding(.horizontal, 20)

            WaybleZoneDropDown(options: ["최신순", "이름순"], selection: $selected)
                .padding(.vertical, 10)
                .padding(.top, 15)
                .padding(.leading, 20)



            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(vm.places) { place in
                        NavigationLink {
                            SavedPlaceListCardView(selectedIndex: $selectedIndex, place: place)
                        } label: {
                            HStack(alignment: .center, spacing: 12) {
                                Image("Place\(place.color)")
                                    .resizable()
                                    .frame(width: 36, height: 36)
                                    .clipShape(Circle())

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(place.title)
                                        .font(.mainTextSemibold14)
                                        .foregroundStyle(Color("gray-900"))

                                    Text("저장 장소 \(place.savedCount)")
                                        .font(.mainTextRegular12)
                                        .foregroundStyle(Color("gray-700"))
                                }

                                Spacer()
                                WaybleZoneSimpleDropDown(options: ["삭제", "편집"])
                            }
                            .padding(.horizontal, 20)
                        }
                    }
                }
                
                NavigationLink(value: Route.addListView) {
                    Text("리스트 추가하기 +")
                        .font(.mainTextSemibold16)
                        .foregroundStyle(Color("gray-900"))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                .padding(.horizontal, 20)
                .padding(.top, 45)
                
//                Button {
//                    router.push(.addListView)
//                } label: {
//                    Text("리스트 추가하기 +")
//                        .font(.mainTextSemibold16)
//                        .foregroundStyle(Color("gray-900"))
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(
//                            RoundedRectangle(cornerRadius: 12)
//                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
//                        )
//                }
//                .padding(.horizontal, 20)
//                .padding(.top, 45)
            }
            .padding(.top, 10)

            Spacer(minLength: 30)
        }
        .padding(.top, 20)
        .task { await vm.fetch(sort: currentSort) }
        .task(id: selected) { await vm.fetch(sort: currentSort) }
    }

    private var currentSort: UserPlaceSort {
        selected == "이름순" ? .name : .latest
    }
}


//extension UserPlaceViewModel {
//    @MainActor static var previewLoaded: UserPlaceViewModel {
//        let vm = UserPlaceViewModel()
//        vm.places = [
//            .init(placeId: 1, title: "강남 카페 리스트", color: "Blue",  savedCount: 20),
//            .init(placeId: 2, title: "홍대 맛집",       color: "Red",   savedCount: 8),
//        ]
//        return vm
//    }
//}

//#Preview {
//    SavedPlaceListView(vm: .previewLoaded)    .environment(NavigationRouter())
//     
//}

