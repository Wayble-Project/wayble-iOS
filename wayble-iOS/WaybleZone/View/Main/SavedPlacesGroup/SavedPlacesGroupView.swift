//import SwiftUI
//
//struct SavedPlacesGroupView: View {
//    @Environment(NavigationRouter.self) var router
//    @Bindable var vm: UserPlaceViewModel
////    @State var collections: [SavedPlace]
//    @Binding var selectedIndex: Int
//    @State private var showAll: Bool = false
//    @State private var selected = "최신순"
//
//
//    var body: some View {
//        Color("gray-100")
//                .frame(height: 10)
//                .frame(maxWidth: .infinity)
//                .padding(.bottom, 20)
//        
//        VStack(alignment: .leading, spacing: 16) {
//
//            Text("내가 저장한 장소")
//                           .font(.mainTextSemibold20)
//                           .foregroundStyle(Color("gray-900"))
//                           .onTapGesture {
//                               router.push(.savedPlaceListView)
//                           }
//            
//            WaybleZoneDropDown( options: ["최신순", "이름순"], selection: $selected)
//                .padding(.vertical, 5)
//                .padding(.bottom, 5)
//
//
////            // 그룹 리스트
////            ForEach(visiblePlaces, id: \.placeId) { place in
////                HStack(spacing: 11) {
////                   Image("Place\(place.color)")
////                        .frame(width: 36, height: 36)
////
////                    VStack(alignment: .leading, spacing: 2) {
////                        Text(place.title)
////                            .font(.mainTextSemibold14)
////                            .foregroundStyle(Color("gray-900"))
////                        Text("저장 장소 \(place.savedCount)")
////                            .font(.mainTextRegular12)
////                            .foregroundStyle(Color("gray-700"))
////                    }
////                }
////            }
//            
//            ForEach(visiblePlaces) { place in
//                NavigationLink {
////                    SavedPlaceListCardView(selectedIndex: $selectedIndex, place: place, selectedPlaceID: <#Binding<Int?>#>)
//                } label: {
//                    HStack(spacing: 11) {
//                        Image("Place\(place.color)")
//                            .resizable()
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
//                        Spacer()
//                    }
//                    .contentShape(Rectangle())   // 빈 공간도 탭 인식
//                    .padding(.vertical, 4)
//                }
//                .buttonStyle(.plain)             // 기본 파란 하이라이트 제거
//            }
//
//            // 더보기 버튼(4개 이상)
//            if vm.places.count > 2 && !showAll {
//                ZStack {
//                
//                            Rectangle()
//                                .fill(Color("gray-200"))
//                                .frame(height: 1)
//
//                            Button {
//                                withAnimation(.easeInOut) {
//                                                showAll = true
//                                            }
//                            } label: {
//                                HStack(spacing: 4) {
//                                    Text("더보기")
//                                        .font(.mainTextSemibold14)
//                                        .foregroundStyle(Color("gray-900"))
//                                    Image(systemName: "chevron.right")
//                                        .foregroundStyle(Color("gray-700"))
//                                        .frame(width: 10, height: 5)
//                                    
//                                }
//                                .padding(.horizontal, 16)
//                                .padding(.vertical, 6)
//                                .background(Color("gray-100"))
//                                .clipShape(Capsule())
//                            }
//                        } .padding(.top, 10)
//                       
//            }
//        } .padding(.horizontal, 20)
//           
//            .task { await vm.fetch(sort: .latest) }
//    }
//
//
////    var sortedGroups: [SavedPlaceGroup] {
////        switch selectedSort {
////        case .name:
////            return allGroups.sorted { $0.name < $1.name }
////        case .recent:
////            return allGroups.reversed() //timestamp로
////        }
////    }
//    private var visiblePlaces: [SimpleSavedPlaceResponse] {
//            showAll ? vm.places : Array(vm.places.prefix(2))
//        }
//
//}
import SwiftUI

struct SavedPlacesGroupView: View {
    @Bindable var vm: UserPlaceViewModel
    @Binding var selectedIndex: Int
    @State private var showAll: Bool = false
    @State private var selected = "최신순"

    // 선택된 리스트를 상위(MainView 등)로 전달해 23번 화면에서 사용
    @Binding var selectedSavedPlace: SimpleSavedPlaceResponse?
    //@Binding var selectedPlaceID: Int?
    
    var body: some View {
        // 상단 회색 바 (기존 유지)
        Color("gray-100")
            .frame(height: 10)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 20)

        // 콘텐츠
        VStack(alignment: .leading, spacing: 16) {

            // 섹션 타이틀 (탭 → 전체 리스트 화면으로 전환)
            Text("내가 저장한 장소")
                .font(.mainTextSemibold20)
                .foregroundStyle(Color("gray-900"))
                .onTapGesture {
                    withAnimation { selectedIndex = 19 } // SavedPlaceListView 인덱스
                }

            // 정렬 드롭다운 (UI 유지)
            WaybleZoneDropDown(options: ["최신순", "이름순"], selection: $selected)
                .padding(.vertical, 5)
                .padding(.bottom, 5)

            // 미리보기 리스트 (NavigationLink 제거)
            ForEach(visiblePlaces) { place in
                Button {
                  
                    selectedSavedPlace = place
                    withAnimation { selectedIndex = 24 } // SavedPlaceListCardView 인덱스
                    
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

            // 더보기 버튼 (기존 UI/애니메이션 그대로)
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
                }
                .padding(.top, 10)
            }
        }
        .padding(.horizontal, 20)
        .onChange(of: selectedIndex) { _, newValue in
            print("selectedIndex ->", newValue)
        }
        .task { await vm.fetch(sort: .latest) }
    }

    // 미리보기 개수(기존: 2개, 더보기 시 전체)
    private var visiblePlaces: [SimpleSavedPlaceResponse] {
        showAll ? vm.places : Array(vm.places.prefix(2))
    }
}
