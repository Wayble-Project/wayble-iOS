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
    @Bindable var viewModel: SearchViewModel
    @FocusState private var isFocused: Bool
    @State private var mapDetailViewID = UUID()
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
                SearchHistoryListView(history: viewModel.searchModels)
            } else {
                suggestionListView()
            }
            
            Spacer()
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
    
    private func suggestionListView() -> some View {
        VStack(spacing: 0) {
            ForEach(Array(viewModel.suggestionKeywords.prefix(3).enumerated()), id: \.element) { index, keyword in
                HStack(spacing: 11) {
                    Image("search")
                    getHighlightedText(keyword, keyword: viewModel.searchText)
                        .font(.mainTextRegular16)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 18)

                if index < 2 {
                    Divider().padding(.horizontal, 20)
                }
            }

            Rectangle()
                .frame(height: 3)
                .foregroundStyle(Color.gray300)

            let suggestions = Array(viewModel.suggestions.prefix(4).enumerated())
            ForEach(suggestions, id: \.element.id) { index, place in
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

                    if index < viewModel.suggestions.prefix(4).count - 1 {
                        Divider()
                    }
                }
                .padding(.top, index == 0 ? 17 : 0)
                .padding(.bottom, 17)
                .padding(.horizontal, 20)
                .onTapGesture {
                    print("선택한 장소: \(place.title), x: \(place.x ?? "nil"), y: \(place.y ?? "nil")")
                    viewModel.selectedPlace = place
                    self.place = place
                    self.mapDetailViewID = UUID()

                    if let entryType { // 길찾기 모드: 출발/도착 중 하나 선택
                        switch entryType {
                        case .departure:
                            // 부모로 출발 선택 전달 + 뷰모델 플래그 세팅
                            onSelectDeparture?(place)
                            SearchViewModel.shared.setPlace(place, for: .departure)
                            $selectedIndex.wrappedValue = 15
                        case .destination:
                            onSelectDestination?(place)
                            SearchViewModel.shared.setPlace(place, for: .destination) 
                            $selectedIndex.wrappedValue = 15
                        }
                    } else {
                        // 기존 플로우: 상세로 이동
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
