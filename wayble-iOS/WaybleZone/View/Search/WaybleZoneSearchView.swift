//import SwiftUI
//import Observation
//
//struct SearchPlace: Identifiable, Hashable, Sendable {
//    let id = UUID()
//    let name: String
//    let distanceMeters: Double
//}
//
//protocol PlaceSearchServiceProtocol: Sendable {
//    func search(keyword: String) async throws -> [SearchPlace]
//}
//
//struct MockPlaceSearchService: PlaceSearchServiceProtocol {
//    func search(keyword: String) async throws -> [SearchPlace] {
//        let all = [
//            SearchPlace(name: "맥도날드 서울역점", distanceMeters: 600),
//            SearchPlace(name: "맥도날드 명동점",   distanceMeters: 2300),
//            SearchPlace(name: "맥도날드 공덕점",   distanceMeters: 1900),
//        ]
//        return all.filter { keyword.isEmpty || $0.name.localizedCaseInsensitiveContains(keyword) }
//    }
//}
//
//
//
//struct WaybleZoneSearchView: View {
//
//    @Bindable  var vm: ZoneSearchViewModel
//    @FocusState  var isFocused: Bool
//    @Environment(\.dismiss)  var dismiss
//
//
//    var body: some View {
//        VStack(spacing: 0) {
//            searchBar
//                .padding(.horizontal, 16)
//                .padding(.vertical, 8)
//
//            if vm.isLoading {
//                ProgressView().padding(.top, 12)
//            }
//
//            List {
//                ForEach(vm.results) { item in
//                    buttonRow(item)
//                }
//            }
//            .listStyle(.plain)
//        }
//        .onAppear { isFocused = true }
//        .navigationBarBackButtonHidden(true)
//        //.tint(.brandDarkBlue)
//        // 🔥 최신 패턴: 값 변화 감지 → 사이드이펙트
//        .onChange(of: vm.query) { newValue in
//            vm.scheduleSearch(for: newValue)
//        }
//    }
//
//    private var searchBar: some View {
//        HStack(spacing: 10) {
//            HStack(spacing: 10) {
//                BackButton()
//
//                TextField("검색", text: $vm.query)
//                    .font(.mainTextRegular14)
//                    .foregroundColor(Color("gray-500"))
//                    .textInputAutocapitalization(.never)
//                    .tracking(-0.28)
//                    .autocorrectionDisabled()
//                    .focused($isFocused)
//
//                if !vm.query.isEmpty {
//                    Button {
//                        vm.clear()
//                        isFocused = true
//                    } label: {
//                        Image(systemName: "xmark.circle.fill")
//                            .font(.mainTextSemibold16)
//                            .foregroundStyle(Color("gray-900"))
//                    }
//                }
//            }
//            .frame(maxWidth: 290, maxHeight: 50)
//            .background(
//                RoundedRectangle(cornerRadius: 15)
//                    .stroke(Color("gray-300"), lineWidth: 1)
//            )
//            .padding(.vertical, 15)
//            .padding(.horizontal, 20)
////            .background(
////                RoundedRectangle(cornerRadius: 16, style: .continuous)
////                    .fill(Color(.separator))
////            )
////            .overlay(
////                RoundedRectangle(cornerRadius: 16, style: .continuous)
////                    .strokeBorder(Color(.separator), lineWidth: 1)
////            )
//        }
//    }
//
//    @ViewBuilder
//    private func buttonRow(_ place: SearchPlace) -> some View {
//        Button {
//            // TODO: 라우팅 연결
//        } label: {
//            HStack(alignment: .firstTextBaseline) {
//                highlightedText(place.name, keyword: vm.query)
//                    .lineLimit(1)
//                Spacer(minLength: 12)
//                Text(distanceString(place.distanceMeters))
//                    .font(.mainTextSemibold14)
//                    .foregroundStyle(Color("gray-900"))
//            }
//            .contentShape(Rectangle())
//            .padding(.vertical, 8)
//        }
//    }
//
//    private func distanceString(_ meters: Double) -> String {
//        meters < 1000 ? "\(Int(meters))m" : String(format: "%.1fkm", meters/1000)
//    }
//
//    private func highlightedText(_ text: String, keyword: String) -> some View {
//        let base: Font = .mainTextRegular16
//        let bold: Font = .mainTextSemibold16
//
//        var attr = AttributedString(text)
//        attr.font = base
//        attr.foregroundColor = .gray900
//
//        if !keyword.isEmpty {
//            let lower = text.lowercased(), key = keyword.lowercased()
//            var range = lower.startIndex..<lower.endIndex
//            while let found = lower.range(of: key, range: range) {
//                if let s = AttributedString.Index(found.lowerBound, within: attr),
//                   let e = AttributedString.Index(found.upperBound, within: attr) {
//                    attr[s..<e].font = bold
//                    attr[s..<e].foregroundColor = .blue700
//                }
//                range = found.upperBound..<lower.endIndex
//            }
//        }
//        return Text(attr)
//    }
//}
//
//
//
//
//
//
//#Preview() {
//   WaybleZoneSearchView(vm: ZoneSearchViewModel())
//        .environment(NavigationRouter())
//}


import SwiftUI
import Observation

struct WaybleZoneSearchView: View {
    // MapSearchViewModel 직접 사용 (DI 필요 없으면 내부 보관)
    @State private var mapVM = MapSearchViewModel()
    @Binding var selectedIndex: Int
    // TextField는 Optional을 바인딩 못 하므로 로컬 query 유지
    @State private var query: String = ""
    @FocusState private var isFocused: Bool
    @Environment(NavigationRouter.self) var router
    @Binding var selectedDeparture: PlaceModel?
    @Binding var selectedArrival: PlaceModel?

    var body: some View {
        @Bindable var mapVM = mapVM

        VStack(spacing: 0) {
            searchBar
                .padding(.horizontal, 16)
                .padding(.vertical, 8)

            if mapVM.isLoading {
                ProgressView().padding(.top, 12)
                    .progressViewStyle(CircularProgressViewStyle(tint: .loading))
            }

            List {
                ForEach(mapVM.items, id: \.waybleZoneInfo.zoneId) { item in
                    buttonRow(item)
                        // 무한 스크롤: 마지막 셀에서 다음 페이지 로드
                        .task {
                            if item.waybleZoneInfo.zoneId == mapVM.items.last?.waybleZoneInfo.zoneId {
                                await mapVM.loadMore()
                            }
                        }
                }
            }
            .listStyle(.plain)
        }
        .onAppear { isFocused = true }
        .navigationBarBackButtonHidden(true)
        .task(id: query) {
            let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
            // 300ms 디바운스
            try? await Task.sleep(nanoseconds: 300_000_000)
            guard !Task.isCancelled else { return } //디바운스 취소 안전장치

            if trimmed.isEmpty {
                mapVM.items.removeAll()
                mapVM.zoneName = nil
            } else {
                mapVM.zoneName = trimmed
                //mapVM.page = 0
                await mapVM.refresh() //여기서 현재 위치 딱 한 번 조회
            }
        }
    }

    // MARK: - Subviews

    private var searchBar: some View {
        HStack(spacing: 10) {
            HStack(spacing: 10) {
                BackButton(action: {
                    selectedIndex = 7
                })
               // WZBackButton(router: router)
                TextField("검색", text: $query)
                    .font(.mainTextRegular14)
                    .foregroundStyle(Color("darkblue-500"))
                    .textInputAutocapitalization(.never)
                    .tracking(-0.28)
                    .autocorrectionDisabled()
                    .focused($isFocused)

                if !query.isEmpty {
                    Button {
                        query = ""
                        isFocused = true
                    } label: {
                        Image("xButton")
                            .font(.mainTextSemibold16)
                            .foregroundStyle(Color("gray-900"))
                            .padding(.horizontal, 10)
                    }
                }
            }
            .frame(maxWidth: 330, maxHeight: 50)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color("gray-300"), lineWidth: 1)
            )
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
        }
    }

//    @ViewBuilder
//    private func buttonRow(_ item: WaybleZoneMapSearchItem) -> some View {
//        let name = item.waybleZoneInfo.zoneName
//        let meters = item.distance * 1000.0
//
//        Button {
//            router.push(.placeDetailView(id: item.waybleZoneInfo.zoneId))
//        } label: {
//            HStack(alignment: .firstTextBaseline) {
//                highlightedText(name, keyword: query)
//                    .lineLimit(1)
//                Spacer(minLength: 12)
//                Text(distanceString(meters))
//                    .font(.mainTextSemibold14)
//                    .foregroundStyle(Color("gray-900"))
//            }
//            .contentShape(Rectangle())
//            .padding(.vertical, 8)
//        }
//        .buttonStyle(.plain)
//    }
    @ViewBuilder
    private func buttonRow(_ item: WaybleZoneMapSearchItem) -> some View {
        let name = item.waybleZoneInfo.zoneName
        let meters = item.distance * 1000.0
        let zoneID = item.waybleZoneInfo.zoneId

        NavigationLink {
            // 목적지 뷰를 직접 생성해서 전달
            PlaceDetailView(
                vm: PlaceDetailViewModel(zoneID: zoneID),
                selectedIndex: $selectedIndex,
                selectedDeparture: $selectedDeparture,
                selectedArrival: $selectedArrival
            )
            .navigationBarBackButtonHidden(true)
        } label: {
            HStack(alignment: .firstTextBaseline) {
                highlightedText(name, keyword: query).lineLimit(1)
                Spacer(minLength: 12)
                Text(distanceString(meters))
                    .font(.mainTextSemibold14)
                    .foregroundStyle(Color("gray-900"))
            }
            .contentShape(Rectangle())
            .padding(.vertical, 8)
        }
        .buttonStyle(.plain) // 리스트 하이라이트 줄이고 싶으면 유지
    }


    // MARK: - Utils

    private func distanceString(_ meters: Double) -> String {
        meters < 1000 ? "\(Int(meters))m" : String(format: "%.1fkm", meters / 1000)
    }

    private func highlightedText(_ text: String, keyword: String) -> some View {
        let base: Font = .mainTextRegular16
        let bold: Font = .mainTextSemibold16

        var attr = AttributedString(text)
        attr.font = base
        attr.foregroundColor = .gray900

        if !keyword.isEmpty {
            let lower = text.lowercased(), key = keyword.lowercased()
            var range = lower.startIndex..<lower.endIndex
            while let found = lower.range(of: key, range: range) {
                if let s = AttributedString.Index(found.lowerBound, within: attr),
                   let e = AttributedString.Index(found.upperBound, within: attr) {
                    attr[s..<e].font = bold
                    attr[s..<e].foregroundColor = .blue700
                }
                range = found.upperBound..<lower.endIndex
            }
        }
        return Text(attr)
    }
}

//#Preview {
//    WaybleZoneSearchView()
//        .withRouter(selectedIndex: .constant(0))
//        .environment(NavigationRouter())
//}
