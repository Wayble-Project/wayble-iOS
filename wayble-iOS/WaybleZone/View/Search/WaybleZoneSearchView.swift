//import SwiftUI
//
//struct WaybleZoneSearchResult: Identifiable {
//    let id = UUID()
//    let name: String
//    let distance: String
//}
//
//@Observable
//final class WaybleZoneSearchViewModel {
//    var query: String = ""
//    var results: [WaybleZoneSearchResult] = []
//
//    private var currentTask: Task<Void, Never>?
//
//    func debounceSearch() {
//        currentTask?.cancel()
//        currentTask = Task {
//            try? await Task.sleep(nanoseconds: 300_000_000)
//            if Task.isCancelled { return }
//            await MainActor.run {
//                performSearch()
//            }
//        }
//    }
//
//    func performSearch() {
//        guard !query.isEmpty else {
//            results = []
//            return
//        }
//
//        let mockData = [
//            WaybleZoneSearchResult(name: "맥도날드 서울역점", distance: "600m"),
//            WaybleZoneSearchResult(name: "맥도날드 명동점", distance: "2.3km"),
//            WaybleZoneSearchResult(name: "맥도날드 공덕점", distance: "1.9km")
//        ]
//
//        results = mockData.filter { $0.name.contains(query) }
//    }
//}
//
//
//struct WaybleZoneSearchView: View {
//    @Bindable var viewModel: WaybleZoneSearchViewModel
//
//    var body: some View {
//        VStack(spacing: 0) {
//            HStack {
//                BackButton()
//                HStack {
//                    TextField("검색어를 입력하세요", text: $viewModel.query)
//                        .font(.mainTextRegular14)
//                        .padding(12)
//                        .background(Color.white)
//                        .clipShape(RoundedRectangle(cornerRadius: 16))
//                        .onChange(of: viewModel.query) { _, _ in
//                            viewModel.debounceSearch()
//                        }
//
//                    if !viewModel.query.isEmpty {
//                        Button {
//                            viewModel.query = ""
//                        } label: {
//                            Image(systemName: "xmark.circle.fill")
//                                .foregroundStyle(.gray)
//                        }
//                        .padding(.trailing, 8)
//                    }
//                }
//                .padding(.leading, 10)
//                .frame(height: 44)
//                .background(Color.gray.opacity(0.1))
//                .clipShape(RoundedRectangle(cornerRadius: 22))
//            }
//            .padding()
//
//            Divider()
//
//            ScrollView {
//                LazyVStack(alignment: .leading, spacing: 20) {
//                    ForEach(viewModel.results) { result in
//                        HStack {
//                            Text(result.name)
//                                .font(.mainTextRegular16)
//                                .foregroundStyle(Color("blue-500"))
//                                .padding(.leading, 16)
//
//                            Spacer()
//
//                            Text(result.distance)
//                                .font(.mainTextRegular14)
//                                .foregroundStyle(Color.gray)
//                                .padding(.trailing, 16)
//                        }
//                        Divider()
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
//    WaybleZoneSearchView(viewModel: WaybleZoneSearchViewModel())
//            .withRouter()
//}




import SwiftUI

struct WaybleZoneSearchView: View {
    var body: some View {
        Text("WaybleZoneSearchView")
    }
}

#Preview {
    WaybleZoneSearchView()
}
