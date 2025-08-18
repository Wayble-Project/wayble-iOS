//
//  SearchBarView.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/11/25.
//

import SwiftUI
import Foundation

// MARK: - SearchRow
struct SearchRow: View {
    let icon: String
    let title: String
    let date: String

    var body: some View {
        HStack {
            Image(icon)
            Spacer()
                .frame(width: 17)
            Text(title)
                .font(.mainTextRegular16)
            Spacer()
            Text(date)
                .foregroundStyle(Color.gray700)
        }
        .padding(.vertical, 14)
        .padding(.leading, 26)
        .padding(.trailing, 20)
    }
}

struct SearchBarView: View {
    @Environment(NavigationRouter.self) private var router
    @EnvironmentObject var searchRoute: SearchRouteState
    @Bindable var viewModel: SearchViewModel = .shared
    @FocusState private var isFocused: Bool
    @State private var mapDetailViewID = UUID()
    @State private var isSavingRecord: Bool = false
    @Binding var place: PlaceModel
    @Binding var selectedIndex: Int
    var entryType: EntryType? = nil // 출발/도착 구분 필요 시만 사용
    // 선택 콜백 (부모에서 주입해주면 출발/도착 값을 안전하게 올려보낼 수 있음)
    var onSelectDeparture: ((PlaceModel) -> Void)? = nil
    var onSelectDestination: ((PlaceModel) -> Void)? = nil
    
    var body: some View {
        
        Spacer()
            .frame(height: 12)
        VStack {
            HStack{
                HStack() {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            switch searchRoute.entryPoint {
                            case .home:
                                $selectedIndex.wrappedValue = 0
                            case .directions:
                                $selectedIndex.wrappedValue = 3
                            }
                        }
                    }) {
                        Image("back2")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    
                    
                    ZStack(alignment: .leading) {
                        if viewModel.searchText.isEmpty {
                            Text("ex.숙대입구역 맛집")
                                .foregroundStyle(.gray500)
                                .font(.mainTextRegular14)
                                .padding(.leading, 4) // 살짝 들여쓰기 맞춰주기
                        }
                        
                        TextField("", text: $viewModel.searchText)
                            .foregroundStyle(.black)
                            .font(.mainTextRegular14)
                            .focused($isFocused)
                    }
                    .onTapGesture {
                        isFocused = true // 빈공간 눌러도 텍스트 서치 가능
                    }
                    .onChange(of: viewModel.searchText) { newValue in
                        Task {
                            try? await viewModel.fetchNaverSuggestions(for: newValue)
                        }
                    }
                    
                    Spacer()
                    
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity, maxHeight: 50)
                .background(Color.white)
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .inset(by: 0.5)
                        .stroke(Color.gray300, lineWidth: 1)
                )
                Spacer()
                    .frame(width:10)
                
                //누르면 지도 펼쳐짐
                Button(action: {
                    $selectedIndex.wrappedValue = 6
                }) {
                    Image("map02")
                        .padding(.horizontal, 12)
                        .padding(.vertical, 15)
                        .frame(width: 50, height: 50, alignment: .center)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .inset(by: 0.5)
                                .stroke(Color.gray300, lineWidth: 1)
                            
                        )
                }
            }
            .padding(.horizontal, 20)
            
            Rectangle()
                .foregroundStyle(.clear)
                .frame(maxWidth: .infinity)
                .frame(height: 12)
                .background(.white)
                .shadow(color: .black.opacity(0.05), radius: 2, x: 0, y: 6)
            
            Spacer()
                .frame(height: 24)
            
            
            HStack(spacing: 16) {
                Button(action: {}) {
                    FilterTagView(label: "집")
                }
                Button(action: {}) {
                    FilterTagView(label: "회사")
                }
                Button(action: {}) {
                    FilterTagView(label: "학교")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 20)
            
            Spacer()
                .frame(height: 14)
            
            if viewModel.searchText.isEmpty {
                if viewModel.searchHistoryUI.isEmpty {
                    Text("최근 검색이 없어요")
                        .font(.mainTextRegular14)
                        .foregroundStyle(Color.gray500)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 8)
                   
                } else {
                    Text("최근 검색")
                        .font(.mainTextSemibold14)
                        .foregroundStyle(Color.gray900)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 6)
                }
                SearchHistoryListView(history: viewModel.searchHistoryUI) { item in
                    viewModel.searchText = item.title
                    Task { try? await viewModel.fetchNaverSuggestions(for: item.title) }
                }
            } else {
                VStack(alignment: .leading, spacing: 6) {
                    suggestionListView()
                }
            }
            Spacer()
        }
        .task {
         
            if viewModel.searchHistoryUI.isEmpty {
                await viewModel.loadHistoriesFromServer()
            }
        }
        .padding(.top)
    }
    
    
    
    
    // MARK: 추천어 강조 Blue700
    private func getHighlightedText(_ suggestion: String, keyword: String) -> Text {
        if suggestion.lowercased().hasPrefix(keyword.lowercased()) {
            let highlightedPart = Text(String(suggestion.prefix(keyword.count)))
                .foregroundStyle(Color.blue700)
            let remainingPart = Text(String(suggestion.dropFirst(keyword.count)))
                .foregroundStyle(Color.black)
            return highlightedPart + remainingPart
        } else {
            return Text(suggestion)
                .foregroundStyle(Color.black)
        }
    }
    
    
    struct FilterTagView: View {
        let label: String
        
        var body: some View {
            Text(label)
                .font(.mainTextSemibold14)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(Color.blue500)
                .cornerRadius(40)
        }
    }
    
    // MARK: - Suggestion Row (extract to reduce type-checker load)
    struct PlaceSuggestionRow: View {
        let place: PlaceModel
        let showTopPadding: Bool
        let showDivider: Bool

        var body: some View {
            VStack(alignment: .leading, spacing: 9.5) {
                HStack(spacing: 11) {
                    Image("marker")
                        .frame(width: 24, height: 24)
                    Text(place.title.removeHTMLTags())
                        .font(.mainTextSemibold16)
                        .foregroundStyle(.black)
                    Spacer()
                }

                Text(place.roadAddress)
                    .font(.mainTextRegular12)
                    .foregroundStyle(.gray700)
                    .padding(.leading, 31)
                    .padding(.bottom, 10)

                if showDivider { Divider() }
            }
            .padding(.top, showTopPadding ? 17 : 0)
            .padding(.bottom, 17)
            .padding(.horizontal, 20)
        }
    }
    
    private func suggestionListView() -> some View {
        VStack(spacing: 0) {
            let items: [PlaceModel] = Array(viewModel.suggestions.prefix(4))
            ForEach(items, id: \.id) { place in
                PlaceSuggestionRow(
                    place: place,
                    showTopPadding: place == items.first,
                    showDivider: place != items.last
                )
                .contentShape(Rectangle())
                .onTapGesture {
                    if isSavingRecord { return }
                    isSavingRecord = true

                    let xStr = place.x ?? "nil"
                    let yStr = place.y ?? "nil"
                    print("선택한 장소: \(place.title), x: \(xStr), y: \(yStr)")
                    viewModel.selectedPlace = place
                    viewModel.searchText = "" // 히스토리 섹션을 보이게 전환
                    self.place = place
                    self.mapDetailViewID = UUID()

                    Task {
                        defer { isSavingRecord = false }
                        await viewModel.saveSearchRecord(for: place)
                    }
                    
                    
                    if let entryType {
                        switch entryType {
                        case .departure:
                            onSelectDeparture?(place)
                            viewModel.setPlace(place, for: .departure)
                            $selectedIndex.wrappedValue = 15
                        case .destination:
                            onSelectDestination?(place)
                            viewModel.setPlace(place, for: .destination)
                            $selectedIndex.wrappedValue = 15
                        }
                    } else {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            $selectedIndex.wrappedValue = 17
                            print(" selectedIndex set to 17")
                        }
                    }
                }
            }
        }
    }
    
    //    #Preview {
    //        SearchBarView(selectedIndex: .constant(0), entryPoint: .home)
    //    }
    //}
    
} // closes struct SearchBarView

// MARK: - Helpers
extension String {
    func removeHTMLTags() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
