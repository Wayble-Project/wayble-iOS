//////import SwiftUI
//////
//////struct SavedPlaceEditView: View {
//////    @State private var selectedPlaceIDs: Set<Int> = []
//////    @State private var isAllSelected = false
//////
//////    let savedPlace: SavedPlace
//////
//////    var body: some View {
//////        VStack() {
//////
//////            HStack {
//////                BackButton()
//////                Text("저장한 장소 편집")
//////                    .font(.mainTextSemibold20)
//////                    .foregroundStyle(Color("gray-900"))
//////                Spacer()
//////            }
//////            .padding(.horizontal, 20)
//////            .padding(.vertical, 16)
//////
//////            HStack(spacing: 12) {
//////                Image("Place\(savedPlace.color)")
//////                    .resizable()
//////                    .frame(width: 36, height: 36)
//////                    .clipShape(Circle())
//////
//////                VStack(alignment: .leading, spacing: 4) {
//////                    Text(savedPlace.title)
//////                        .font(.mainTextSemibold16)
//////                        .foregroundStyle(Color("gray-900"))
//////                    Text("저장 장소 \(savedPlace.waybleZone.count)")
//////                        .font(.mainTextRegular12)
//////                        .foregroundStyle(Color("gray-700"))
//////                }
//////
//////                Spacer()
//////
//////                Button {
//////                    // onEdit
//////                } label: {
//////                    Text("편집")
//////                        .font(.mainTextSemibold14)
//////                        .foregroundStyle(Color("gray-700"))
//////                        .padding(.horizontal, 25)
//////                        .padding(.vertical, 10)
//////                        .background(Color("gray-100"))
//////                        .clipShape(Capsule())
//////                }
//////
//////            }
//////            .padding(.horizontal, 20)
//////            .padding(.vertical, 10)
//////
//////            Divider()
//////            HStack {
//////                Button {
//////                    isAllSelected.toggle()
//////                    selectedPlaceIDs = isAllSelected
//////                    ? Set(savedPlace.waybleZone.map(\.id))
//////                    : []
//////                } label: {
//////                    Image( isAllSelected ? "check01" : "check05")
//////                        .resizable()
//////                        .frame(width: 24, height: 24)
//////                }.padding(.trailing, 8)
//////
//////                Text("전체 선택")
//////                    .font(.mainTextSemibold16)
//////                    .foregroundStyle(Color("gray-900"))
//////
//////                Spacer()
//////            }
//////            .padding(.horizontal, 20)
//////            .padding(.vertical, 15)
//////            .padding(.bottom, 5)
//////
//////            ScrollView {
//////                VStack(spacing: 24) {
//////                    ForEach(savedPlace.waybleZone) { zone in
//////                        HStack(alignment: .top) {
//////                            if selectedPlaceIDs.contains(zone.id) {
//////                                Button {
//////                                    selectedPlaceIDs.remove(zone.id)
//////                                } label: {
//////                                    Image("check01")
//////                                        .resizable()
//////                                        .frame(width: 24, height: 24)
//////
//////                                }
//////                            } else {
//////                                Button {
//////                                    selectedPlaceIDs.insert(zone.id)
//////                                } label: {
//////                                    Image("check05")
//////                                        .resizable()
//////                                        .frame(width: 24, height: 24)
//////
//////                                }
//////                            }
//////
//////                            WaybleZoneCard(zone: zone)
//////                        }
//////                        .padding(.horizontal, 20)
//////
//////
//////                    }
//////                }
//////                .padding(.bottom, 20)
//////            }
//////
//////
//////            HStack(spacing: 16) {
//////                Button {
//////                    // onCancel
//////                } label: {
//////                    Text("취소")
//////                        .font(.mainTextSemibold16)
//////                        .frame(maxWidth: .infinity)
//////                        .padding()
//////                        .background(Color("gray-100"))
//////                        .foregroundStyle(Color("gray-700"))
//////                        .clipShape(RoundedRectangle(cornerRadius: 13))
//////                }
//////
//////                Button {
//////                    // onDelete
//////                } label: {
//////                    Text("삭제")
//////                        .font(.mainTextSemibold16)
//////                        .frame(maxWidth: .infinity)
//////                        .padding()
//////                        .background(Color("darkblue-500"))
//////                        .foregroundStyle(Color.white)
//////                        .clipShape(RoundedRectangle(cornerRadius: 13))
//////                }
//////            }
//////            .padding(.horizontal, 20)
//////            .padding(.vertical, 16)
//////        }
//////        .navigationBarHidden(true)
//////    }
//////}
//////
//////
////import SwiftUI
////
////struct SavedPlaceEditView: View {
////    @Environment(NavigationRouter.self) private var router
////
////    // 선택 관리
////    @State private var selectedPlaceIDs: Set<Int> = []
////    @State private var isAllSelected = false
////    @State private var isDeleting = false
////
////    // 입력 데이터
////    let savedPlace: SavedPlace
////
////    // 화면 표시용 존 목록 (삭제 후 UI 갱신 위해 로컬 상태로 보유)
////    @State private var zones: [WaybleZone]
////
////    // VM 주입(필요 시 외부에서 넣을 수 있게 기본값 제공)
////    @State private var vm: UserPlaceViewModel
////
////    init(savedPlace: SavedPlace, vm: UserPlaceViewModel = UserPlaceViewModel()) {
////        self.savedPlace = savedPlace
////        _zones = State(initialValue: savedPlace.waybleZone)
////        _vm = State(initialValue: vm)
////    }
////
////    var body: some View {
////        VStack {
////     
////            HStack {
////                BackButton()
////                Text("저장한 장소 편집")
////                    .font(.mainTextSemibold20)
////                    .foregroundStyle(Color("gray-900"))
////                Spacer()
////            }
////            .padding(.horizontal, 20)
////            .padding(.vertical, 16)
////
//// 
////            HStack(spacing: 12) {
////                Image("Place\(savedPlace.color)")
////                    .resizable()
////                    .frame(width: 36, height: 36)
////                    .clipShape(Circle())
////
////                VStack(alignment: .leading, spacing: 4) {
////                    Text(savedPlace.title)
////                        .font(.mainTextSemibold16)
////                        .foregroundStyle(Color("gray-900"))
////
////                    Text("저장 장소 \(zones.count)")
////                        .font(.mainTextRegular12)
////                        .foregroundStyle(Color("gray-700"))
////                }
////
////                Spacer()
////
////              
////                Button {
////                    // onEdit (옵션)
////                } label: {
////                    Text("편집")
////                        .font(.mainTextSemibold14)
////                        .foregroundStyle(Color("gray-700"))
////                        .padding(.horizontal, 25)
////                        .padding(.vertical, 10)
////                        .background(Color("gray-100"))
////                        .clipShape(Capsule())
////                }
////            }
////            .padding(.horizontal, 20)
////            .padding(.vertical, 10)
////
////            Divider()
////
////            // 전체 선택
////            HStack {
////                Button {
////                    isAllSelected.toggle()
////                    selectedPlaceIDs = isAllSelected ? Set(zones.map(\.id)) : []
////                } label: {
////                    Image(isAllSelected ? "check01" : "check05")
////                        .resizable()
////                        .frame(width: 24, height: 24)
////                }
////                .padding(.trailing, 8)
////
////                Text("전체 선택")
////                    .font(.mainTextSemibold16)
////                    .foregroundStyle(Color("gray-900"))
////
////                Spacer()
////            }
////            .padding(.horizontal, 20)
////            .padding(.vertical, 15)
////            .padding(.bottom, 5)
////
////      
////            ScrollView {
////                VStack(spacing: 24) {
////                    ForEach(zones, id: \.id) { zone in
////                        HStack(alignment: .top) {
////                            Button {
////                                toggleSelection(for: zone.id)
////                            } label: {
////                                Image(selectedPlaceIDs.contains(zone.id) ? "check01" : "check05")
////                                    .resizable()
////                                    .frame(width: 24, height: 24)
////                            }
////                            WaybleZoneCard(zone: zone)
////                                .disabled(true) // 편집 화면에서는 카드 탭 이동 막기(선택만)
////                        }
////                        .padding(.horizontal, 20)
////                    }
////                }
////                .padding(.bottom, 20)
////            }
////
////            // 하단 버튼
////            HStack(spacing: 16) {
////                Button {
////
////                } label: {
////                    Text("취소")
////                        .font(.mainTextSemibold16)
////                        .frame(maxWidth: .infinity)
////                        .padding()
////                        .background(Color("gray-100"))
////                        .foregroundStyle(Color("gray-700"))
////                        .clipShape(RoundedRectangle(cornerRadius: 13))
////                }
////
////                Button {
////                    Task { await deleteSelected() }
////                } label: {
////                    ZStack {
////                        Text(isDeleting ? "삭제 중..." : "삭제")
////                            .font(.mainTextSemibold16)
////                            .frame(maxWidth: .infinity)
////                            .padding()
////                            .foregroundStyle(Color.white)
////                            .background(Color("darkblue-500"))
////                            .clipShape(RoundedRectangle(cornerRadius: 13))
////                        if isDeleting {
////                            ProgressView().tint(.white)
////                        }
////                    }
////                }
////                .disabled(isDeleting || selectedPlaceIDs.isEmpty)
////            }
////            .padding(.horizontal, 20)
////            .padding(.vertical, 16)
////        }
////        .navigationBarHidden(true)
////        // 선택 수 변화에 따라 전체선택 토글 동기화
////        .onChange(of: selectedPlaceIDs) { _, newValue in
////            isAllSelected = !zones.isEmpty && newValue.count == zones.count
////        }
////    }
////
////    // MARK: - Helpers
////
////    private func toggleSelection(for id: Int) {
////        if selectedPlaceIDs.contains(id) {
////            selectedPlaceIDs.remove(id)
////        } else {
////            selectedPlaceIDs.insert(id)
////        }
////    }
////
////    @MainActor
////    private func deleteSelected() async {
////        guard !selectedPlaceIDs.isEmpty else { return }
////        isDeleting = true
////        defer { isDeleting = false }
////
////        // 서버에서 삭제
////        for zoneID in selectedPlaceIDs {
////            await vm.remove(placeId: savedPlace.placeID, waybleZoneId: zoneID)
////            // 에러 메시지가 생기면 중단할지 계속할지 정책에 따라 결정
////            // 여기서는 계속 진행
////        }
////
////        // 로컬 UI 반영
////        zones.removeAll { selectedPlaceIDs.contains($0.id) }
////        selectedPlaceIDs.removeAll()
////        isAllSelected = false
////    }
////}
//import SwiftUI
//
//struct SavedPlaceEditView: View {
//    @Environment(NavigationRouter.self) private var router
//    @Bindable var vm: UserPlaceViewModel   // ← 뷰모델 주입(Observation 최신 문법)
//    
//    @State private var selectedIDs: Set<Int> = []
//    @State private var isAllSelected = false
//    @Binding var selectedIndex: Int
//    
//    let savedPlace: SavedPlace
//    
//    var body: some View {
//        VStack {
//            header
//            listHeader
//            
//            ScrollView {
//                LazyVStack(spacing: 16) {
//                    ForEach(savedPlace.waybleZone, id: \.id) { zone in
//                        SelectableZoneRow(
//                            zone: zone,
//                            isSelected: selectedIDs.contains(zone.id),
//                            onToggle: { toggle(zone.id) }
//                        )
//                        .padding(.horizontal, 20)
//                    }
//                }
//                .padding(.vertical, 10)
//            }
//            
//            bottomBar
//        }
//        .navigationBarBackButtonHidden(true) // 최신 API
//    }
//}
//
//private extension SavedPlaceEditView {
//    var header: some View {
//        HStack {
//            BackButton()
//            Text("저장한 장소 편집")
//                .font(.mainTextSemibold20)
//                .foregroundStyle(Color("gray-900"))
//            Spacer()
//            Button {
//                // 필요시 리스트 편집 타이틀 변경 등
//            } label: {
//                Text("편집")
//                    .font(.mainTextSemibold14)
//                    .foregroundStyle(Color("gray-700"))
//                    .padding(.horizontal, 25)
//                    .padding(.vertical, 10)
//                    .background(Color("gray-100"))
//                    .clipShape(Capsule())
//            }
//        }
//        .padding(.horizontal, 20)
//        .padding(.vertical, 16)
//        
//    }
//    
//    var listHeader: some View {
//        VStack(spacing: 10) {
//            HStack(spacing: 12) {
//                Image("Place\(savedPlace.color)")
//                    .resizable()
//                    .frame(width: 36, height: 36)
//                    .clipShape(Circle())
//                
//                VStack(alignment: .leading, spacing: 4) {
//                    Text(savedPlace.title)
//                        .font(.mainTextSemibold16)
//                        .foregroundStyle(Color("gray-900"))
//                    Text("저장 장소 \(savedPlace.waybleZone.count)")
//                        .font(.mainTextRegular12)
//                        .foregroundStyle(Color("gray-700"))
//                }
//                Spacer()
//            }
//            .padding(.horizontal, 20)
//            
//            Divider()
//            
//            HStack {
//                Button {
//                    isAllSelected.toggle()
//                    selectedIDs = isAllSelected
//                    ? Set(savedPlace.waybleZone.map(\.id))
//                    : []
//                } label: {
//                    Image(isAllSelected ? "check01" : "check05")
//                        .resizable().frame(width: 24, height: 24)
//                }
//                .padding(.trailing, 8)
//                
//                Text("전체 선택")
//                    .font(.mainTextSemibold16)
//                    .foregroundStyle(Color("gray-900"))
//                Spacer()
//            }
//            .padding(.horizontal, 20)
//            .padding(.vertical, 10)
//        }
//        .padding(.bottom, 5)
//    }
//    
//    var bottomBar: some View {
//        HStack(spacing: 16) {
//            Button {
//                // 취소: 선택 해제 후 뒤로
//                selectedIDs.removeAll()
//                isAllSelected = false
//                router.pop()
//            } label: {
//                Text("취소")
//                    .font(.mainTextSemibold16)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color("gray-100"))
//                    .foregroundStyle(Color("gray-700"))
//                    .clipShape(RoundedRectangle(cornerRadius: 13))
//            }
//            
//            Button {
//                onDelete()
//            } label: {
//                Text("삭제")
//                    .font(.mainTextSemibold16)
//                    .frame(maxWidth: .infinity)
//                    .padding()
//                    .background(Color("darkblue-500"))
//                    .foregroundStyle(.white)
//                    .clipShape(RoundedRectangle(cornerRadius: 13))
//            }
//            .disabled(selectedIDs.isEmpty || vm.isSaving)
//        }
//        .padding(.horizontal, 20)
//        .padding(.vertical, 16)
//    }
//    
//    func toggle(_ id: Int) {
//        if selectedIDs.contains(id) {
//            selectedIDs.remove(id)
//        } else {
//            selectedIDs.insert(id)
//        }
//        isAllSelected = selectedIDs.count == savedPlace.waybleZone.count
//    }
//    
//    func onDelete() {
//        guard !selectedIDs.isEmpty else { return }
//        Task { @MainActor in
//            // UserPlaceViewModel의 단건 삭제 API를 활용해 일괄 삭제
//            for zoneID in selectedIDs {
//                await vm.remove(placeId: savedPlace.placeID, waybleZoneId: zoneID)
//            }
//            // UI 정리
//            selectedIDs.removeAll()
//            isAllSelected = false
//            // 최신 리스트를 다시 불러오고 싶다면:
//            await vm.loadZones(placeId: savedPlace.placeID)
//        }
//    }
//}
//
///// 행(셀)을 별도 뷰로 분리해 타입체커 부담 ↓
//private struct SelectableZoneRow: View {
//    let zone: WaybleZone
//    let isSelected: Bool
//    let onToggle: () -> Void
//    @Binding var selectedIndex: Int
//    
//    var body: some View {
//        HStack(alignment: .top, spacing: 8) {
//            Button(action: onToggle) {
//                Image(isSelected ? "check01" : "check05")
//                    .resizable()
//                    .frame(width: 24, height: 24)
//            }
//            .buttonStyle(.plain)
//            
//            WaybleZoneCard(zone: zone, selectedIndex: $selectedIndex, selectedPlaceID: <#Binding<Int?>#>) // 내부는 NavigationLink, 외부는 HStack
//                .buttonStyle(.plain)
//        }
//    }
//}
