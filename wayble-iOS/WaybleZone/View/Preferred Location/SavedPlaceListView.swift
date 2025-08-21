//import SwiftUI
//
//
//struct SavedPlaceListView: View {
//    @State private var selected = "최신순"
//
//    @State var vm: UserPlaceViewModel
//    @Binding var selectedIndex: Int
//    
//    @Binding var selectedSavedPlace: SimpleSavedPlaceResponse?
//       @Binding var selectedPlaceID: Int?
//   
//   // init(vm: UserPlaceViewModel) { _vm = State(initialValue: vm) }
//
//    var body: some View {
//        VStack(alignment: .leading) {
//       
//            HStack {
//                WZBackButton(selectedIndex: $selectedIndex, toTab: 4).padding(.trailing, 5)
//                
////                BackButton(action: {
////                    selectedIndex = 18
////                })
////                    .padding(.trailing, 5)
//
//                Text("내가 저장한 장소")
//                    .font(.mainTextSemibold20)
//                    .foregroundStyle(Color("gray-900"))
//                Spacer()
//            }
//            .padding(.horizontal, 20)
//
//            WaybleZoneDropDown(options: ["최신순", "이름순"], selection: $selected)
//                .padding(.vertical, 10)
//                .padding(.top, 15)
//                .padding(.leading, 20)
//
//
//
//            ScrollView {
//                LazyVStack(spacing: 16) {
//                    ForEach(vm.places) { place in
//                        NavigationLink {
////                            SavedPlaceListCardView(selectedIndex: $selectedIndex, place: place, selectedPlaceID: <#Binding<Int?>#>)
//                        } label: {
//                            HStack(alignment: .center, spacing: 12) {
//                                Image("Place\(place.color)")
//                                    .resizable()
//                                    .frame(width: 36, height: 36)
//                                    .clipShape(Circle())
//
//                                VStack(alignment: .leading, spacing: 4) {
//                                    Text(place.title)
//                                        .font(.mainTextSemibold14)
//                                        .foregroundStyle(Color("gray-900"))
//
//                                    Text("저장 장소 \(place.savedCount)")
//                                        .font(.mainTextRegular12)
//                                        .foregroundStyle(Color("gray-700"))
//                                }
//
//                                Spacer()
//                                WaybleZoneSimpleDropDown(options: ["삭제", "편집"])
//                            }
//                            .padding(.horizontal, 20)
//                        }
//                    }
//                }
//                
//                NavigationLink(value: Route.addListView) {
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
//                
////                Button {
////                    router.push(.addListView)
////                } label: {
////                    Text("리스트 추가하기 +")
////                        .font(.mainTextSemibold16)
////                        .foregroundStyle(Color("gray-900"))
////                        .frame(maxWidth: .infinity)
////                        .padding()
////                        .background(
////                            RoundedRectangle(cornerRadius: 12)
////                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
////                        )
////                }
////                .padding(.horizontal, 20)
////                .padding(.top, 45)
//            }
//            .padding(.top, 10)
//
//            Spacer(minLength: 30)
//        }
//        .padding(.top, 20)
//        .task { await vm.fetch(sort: currentSort) }
//        .task(id: selected) { await vm.fetch(sort: currentSort) }
//    }
//
//    private var currentSort: UserPlaceSort {
//        selected == "이름순" ? .name : .latest
//    }
//}
//
//
//
import SwiftUI

struct SavedPlaceListView: View {
    @State private var selected = "최신순"

    @State var vm: UserPlaceViewModel
    @Binding var selectedIndex: Int


    @Binding var selectedSavedPlace: SimpleSavedPlaceResponse?
    @Binding var selectedPlaceID: Int?

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
                        .contentShape(Rectangle())
                        .onTapGesture {
                      
                            selectedSavedPlace = place
                            withAnimation { selectedIndex = 24 }
                        }
                    }
                }
                Button {
                      withAnimation { selectedIndex = 25 }
                  } label: {
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
