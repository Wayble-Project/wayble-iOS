import SwiftUI
import Observation

struct SearchPlace: Identifiable, Hashable, Sendable {
    let id = UUID()
    let name: String
    let distanceMeters: Double
}

protocol PlaceSearchServiceProtocol: Sendable {
    func search(keyword: String) async throws -> [SearchPlace]
}

struct MockPlaceSearchService: PlaceSearchServiceProtocol {
    func search(keyword: String) async throws -> [SearchPlace] {
        let all = [
            SearchPlace(name: "맥도날드 서울역점", distanceMeters: 600),
            SearchPlace(name: "맥도날드 명동점",   distanceMeters: 2300),
            SearchPlace(name: "맥도날드 공덕점",   distanceMeters: 1900),
        ]
        return all.filter { keyword.isEmpty || $0.name.localizedCaseInsensitiveContains(keyword) }
    }
}


@MainActor
@Observable
final class ZoneSearchViewModel {
    // State
    var query = ""
    var results: [SearchPlace] = []
    var isLoading = false

    // DI
    private let service: PlaceSearchServiceProtocol
    private var searchTask: Task<Void, Never>?

    // 지정 이니셜라이저
    init(service: PlaceSearchServiceProtocol) {
        self.service = service
    }

    // 편의 이니셜라이저 (미제공 시 프리뷰/기본 생성에서 에러)
    convenience init() {
        self.init(service: MockPlaceSearchService())
    }

    // onChange에서 호출할 디바운스 검색
    func scheduleSearch(for text: String) {
        searchTask?.cancel()

        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            results = []
            return
        }

        searchTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: 300_000_000) // 300ms debounce
            guard let self, !Task.isCancelled else { return }

            isLoading = true
            defer { isLoading = false }

            do {
                results = try await service.search(keyword: trimmed)
            } catch {
                results = []
            }
        }
    }

    func clear() {
        query = ""
        results = []
    }
}

struct WaybleZoneSearchView: View {
    // ⚠️ @State는 '저장' 프로퍼티라 init에서 주입해야 안정적
    @State private var vm: ZoneSearchViewModel
    @FocusState private var isFocused: Bool
    @Environment(\.dismiss) private var dismiss

    // DI 주입용
     @MainActor
     init(vm: ZoneSearchViewModel) {
         self._vm = State(initialValue: vm)
     }

     // 기본 생성용(프리뷰/간편 사용)
     @MainActor
     init() {
         self._vm = State(initialValue: ZoneSearchViewModel())
     }

    var body: some View {
        VStack(spacing: 0) {
            searchBar
                .padding(.horizontal, 16)
                .padding(.vertical, 8)

            if vm.isLoading {
                ProgressView().padding(.top, 12)
            }

            List {
                ForEach(vm.results) { item in
                    buttonRow(item)
                }
            }
            .listStyle(.plain)
        }
        .onAppear { isFocused = true }
        .navigationBarBackButtonHidden(true)
        //.tint(.brandDarkBlue)
        // 🔥 최신 패턴: 값 변화 감지 → 사이드이펙트
        .onChange(of: vm.query) { newValue in
            vm.scheduleSearch(for: newValue)
        }
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            HStack(spacing: 10) {
                BackButton()

                TextField("검색", text: $vm.query)
                    .font(.mainTextRegular14)
                    .foregroundColor(Color("gray-500"))
                    .textInputAutocapitalization(.never)
                    .tracking(-0.28)
                    .autocorrectionDisabled()
                    .focused($isFocused)

                if !vm.query.isEmpty {
                    Button {
                        vm.clear()
                        isFocused = true
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.mainTextSemibold16)
                            .foregroundStyle(Color("gray-900"))
                    }
                }
            }
            .frame(maxWidth: 290, maxHeight: 50)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color("gray-300"), lineWidth: 1)
            )
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
//            .background(
//                RoundedRectangle(cornerRadius: 16, style: .continuous)
//                    .fill(Color(.separator))
//            )
//            .overlay(
//                RoundedRectangle(cornerRadius: 16, style: .continuous)
//                    .strokeBorder(Color(.separator), lineWidth: 1)
//            )
        }
    }

    @ViewBuilder
    private func buttonRow(_ place: SearchPlace) -> some View {
        Button {
            // TODO: 라우팅 연결
        } label: {
            HStack(alignment: .firstTextBaseline) {
                highlightedText(place.name, keyword: vm.query)
                    .lineLimit(1)
                Spacer(minLength: 12)
                Text(distanceString(place.distanceMeters))
                    .font(.mainTextSemibold14)
                    .foregroundStyle(Color("gray-900"))
            }
            .contentShape(Rectangle())
            .padding(.vertical, 8)
        }
    }

    private func distanceString(_ meters: Double) -> String {
        meters < 1000 ? "\(Int(meters))m" : String(format: "%.1fkm", meters/1000)
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


private struct PreviewSearchService: PlaceSearchServiceProtocol {
    func search(keyword: String) async throws -> [SearchPlace] {
        try? await Task.sleep(nanoseconds: 200_000_000) // 0.2s 로딩 연출
        let all = [
            SearchPlace(name: "맥도날드 서울역점", distanceMeters: 600),
            SearchPlace(name: "맥도날드 명동점",   distanceMeters: 2300),
            SearchPlace(name: "맥도날드 공덕점",   distanceMeters: 1900),
        ]
        return all.filter { keyword.isEmpty || $0.name.localizedCaseInsensitiveContains(keyword) }
    }
}

/// 프리뷰 하네스: onAppear에서 query를 세팅해 onChange → 검색 트리거
@MainActor
private struct SearchPreviewHarness: View {
    @State var vm = ZoneSearchViewModel(service: PreviewSearchService())
    var body: some View {
        WaybleZoneSearchView(vm: vm)
            .onAppear { vm.query = "맥도날드" }  // 프리뷰 진입 시 검색 실행
    }
}

#Preview("Search - Light") {
    NavigationStack { SearchPreviewHarness() }
}
