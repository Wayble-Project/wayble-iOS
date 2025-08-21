import SwiftUI

struct SavedPlacesGroupView: View {
    @Environment(NavigationRouter.self) var router
    @Bindable var vm: UserPlaceViewModel
//    @State var collections: [SavedPlace]
    @Binding var selectedIndex: Int
    @State private var showAll: Bool = false
    @State private var selected = "최신순"


    var body: some View {
        Color("gray-100")
                .frame(height: 10)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)
        
        VStack(alignment: .leading, spacing: 16) {

            Text("내가 저장한 장소")
                           .font(.mainTextSemibold20)
                           .foregroundStyle(Color("gray-900"))
                           .onTapGesture {
                               router.push(.savedPlaceListView)
                           }
            
            WaybleZoneDropDown( options: ["최신순", "이름순"], selection: $selected)
                .padding(.vertical, 5)
                .padding(.bottom, 5)


//            // 그룹 리스트
//            ForEach(visiblePlaces, id: \.placeId) { place in
//                HStack(spacing: 11) {
//                   Image("Place\(place.color)")
//                        .frame(width: 36, height: 36)
//
//                    VStack(alignment: .leading, spacing: 2) {
//                        Text(place.title)
//                            .font(.mainTextSemibold14)
//                            .foregroundStyle(Color("gray-900"))
//                        Text("저장 장소 \(place.savedCount)")
//                            .font(.mainTextRegular12)
//                            .foregroundStyle(Color("gray-700"))
//                    }
//                }
//            }
            
            ForEach(visiblePlaces) { place in
                NavigationLink {
                    SavedPlaceListCardView(selectedIndex: $selectedIndex, place: place)
                } label: {
                    HStack(spacing: 11) {
                        Image("Place\(place.color)")
                            .resizable()
                            .frame(width: 36, height: 36)
                            .clipShape(Circle())

                        VStack(alignment: .leading, spacing: 2) {
                            Text(place.title)
                                .font(.mainTextSemibold14)
                                .foregroundStyle(Color("gray-900"))
                            Text("저장 장소 \(place.savedCount)")
                                .font(.mainTextRegular12)
                                .foregroundStyle(Color("gray-700"))
                        }

                        Spacer()
                    }
                    .contentShape(Rectangle())   // 빈 공간도 탭 인식
                    .padding(.vertical, 4)
                }
                .buttonStyle(.plain)             // 기본 파란 하이라이트 제거
            }

            // 더보기 버튼(4개 이상)
            if vm.places.count > 2 && !showAll {
                ZStack {
                
                            Rectangle()
                                .fill(Color("gray-200"))
                                .frame(height: 1)

                            Button {
                                withAnimation(.easeInOut) {
                                                showAll = true
                                            }
                            } label: {
                                HStack(spacing: 4) {
                                    Text("더보기")
                                        .font(.mainTextSemibold14)
                                        .foregroundStyle(Color("gray-900"))
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(Color("gray-700"))
                                        .frame(width: 10, height: 5)
                                    
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(Color("gray-100"))
                                .clipShape(Capsule())
                            }
                        } .padding(.top, 10)
                       
            }
        } .padding(.horizontal, 20)
           
            .task { await vm.fetch(sort: .latest) }
    }


//    var sortedGroups: [SavedPlaceGroup] {
//        switch selectedSort {
//        case .name:
//            return allGroups.sorted { $0.name < $1.name }
//        case .recent:
//            return allGroups.reversed() //timestamp로
//        }
//    }
    private var visiblePlaces: [SimpleSavedPlaceResponse] {
            showAll ? vm.places : Array(vm.places.prefix(2))
        }

}

//#Preview {
//    SavedPlacesGroupView(collections: mockSavedPlaces)
//}
//import SwiftUI
//import Observation
//
//struct SavedPlacesGroupView: View {
//    // 최신 Observation: @Observable 뷰모델은 @Bindable 로 바인딩
//    @Bindable var vm: UserPlaceViewModel
//
//    @State private var showAll = false
//    @State private var selected = "최신순" // "최신순" | "이름순"
//
////    init(vm: UserPlaceViewModel = UserPlaceViewModel()) {
////        self.vm = vm
////    }
//
//    var body: some View {
//        VStack(spacing: 0) {
//            Color("gray-100")
//                .frame(height: 10)
//                .frame(maxWidth: .infinity)
//                .padding(.bottom, 20)
//
//            VStack(alignment: .leading, spacing: 16) {
//
//                Text("내가 저장한 장소")
//                    .font(.mainTextSemibold20)
//
//                WaybleZoneDropDown(
//                    options: ["최신순", "이름순"],
//                    selection: $selected
//                )
//                .padding(.vertical, 5)
//                .padding(.bottom, 5)
//                .onChange(of: selected) { _, _ in
//                    Task { await vm.fetch(sort: selectedSort) }
//                }
//
//                // 리스트 (2개만 보여주고 '더보기'로 확장)
//                ForEach(visiblePlaces) { place in
//                    HStack(spacing: 11) {
//                        Image("Place\(place.color)") // 서버 컬러 → 에셋 네이밍 매칭
//                            .resizable()
//                            .scaledToFill()
//                            .frame(width: 36, height: 36)
//                            .clipShape(Circle())
//
//                        VStack(alignment: .leading, spacing: 2) {
//                            Text(place.title)
//                                .font(.mainTextSemibold14)
//                                .foregroundStyle(Color("gray-900"))
//                            Text("저장 장소 \(place.savedCount)")
//                                .font(.mainTextRegular12)
//                                .foregroundStyle(Color("gray-700"))
//                        }
//
//                        Spacer(minLength: 0)
//                    }
//                }
//
//                // 더보기 버튼
//                if vm.places.count > 2 && !showAll {
//                    ZStack {
//                        Rectangle()
//                            .fill(Color("gray-200"))
//                            .frame(height: 1)
//
//                        Button {
//                            withAnimation { showAll = true }
//                        } label: {
//                            HStack(spacing: 4) {
//                                Text("더보기")
//                                    .font(.mainTextSemibold14)
//                                    .foregroundStyle(Color("gray-900"))
//                                Image(systemName: "chevron.right")
//                                    .foregroundStyle(Color("gray-700"))
//                                    .frame(width: 10, height: 5)
//                            }
//                            .padding(.horizontal, 16)
//                            .padding(.vertical, 6)
//                            .background(Color("gray-100"))
//                            .clipShape(Capsule())
//                        }
//                    }
//                    .padding(.top, 10)
//                }
//            }
//            .padding(.horizontal, 20)
//        }
//        // 최초 진입 시 서버 호출
//        .task { await vm.fetch(sort: selectedSort) }
//    }
//
//    // MARK: - Helpers
//    private var visiblePlaces: [SimpleSavedPlaceResponse] {
//        let list = vm.places
//        return showAll ? list : Array(list.prefix(2))
//    }
//
//    private var selectedSort: UserPlaceSort {
//        selected == "이름순" ? .name : .latest
//    }
//}

//#Preview {
//    SavedPlacesGroupView() // 내부에서 VM 생성
//}
