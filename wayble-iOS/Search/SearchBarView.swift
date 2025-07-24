//
//  SearchBarView.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/11/25.
//

import SwiftUI

struct SearchBarView: View {
    @State private var viewModel = SearchViewModel()
    
    var body: some View {
        
        Spacer()
            .frame(height: 12)
        VStack {
            HStack{
                HStack() {
                    Button(action: {
                        // 여기에 dismiss() 추가 예정
                    }) {
                        Image("back2")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                    
                    
                    ZStack(alignment: .leading) {
                                          if viewModel.searchText.isEmpty {
                                              Text("ex.숙대입구역 맛집")
                                                  .foregroundColor(.gray500)
                                                  .font(.mainTextRegular14)
                                                  .padding(.leading, 4) // 살짝 들여쓰기 맞춰주기
                                          }

                                          TextField("", text: $viewModel.searchText)
                                              .foregroundColor(.black)
                                              .font(.mainTextRegular14)
                                      }
                        .onChange(of: viewModel.searchText) { newValue in
                            viewModel.fetchNaverSuggestions(for: newValue)
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
                Button(action: {}) {
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
                .foregroundColor(.clear)
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
                suggestionListView
            }
            
            Spacer()
        }
        .padding(.top)
    }
    
    private var suggestionListView: some View {
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
                    // 3개 중 마지막 전까지만 Divider 표시
                    Divider()
                        .padding(.horizontal, 20)
                }
            }
            Rectangle()
                .frame(height: 3)
                .foregroundStyle(Color.gray300)
               
            
            
            ForEach(Array(viewModel.suggestions.prefix(4).enumerated()), id: \.element.id) { index, place in
                VStack(alignment: .leading, spacing: 9.5) {
                    HStack(alignment: .center, spacing: 11) {
                        Image("marker")
                            .frame(width: 24, height: 24)
                        Text(place.title.removeHTMLTags())
                            .font(.mainTextSemibold16)
                            .foregroundStyle(Color.black)
                        Spacer()
                    }
                    
                    Text(place.roadAddress)
                        .font(.mainTextRegular12)
                        .foregroundStyle(Color.gray700)
                        .padding(.leading, 31)
                        .padding(.bottom, 10)
                    
                    
                    if index < viewModel.suggestions.prefix(4).count - 1 {
                        Divider()
                            
                            
                            
                    }
                }
                .padding(.top, index == 0 ? 17 : 0)
                .padding(.bottom, 17)
                .padding(.horizontal,20)
                .onTapGesture {
                    print("선택된 장소: \(place.title)")
                }
                
                
            }
        }
    }
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
// 집 회사 학교 버튼 커스텀
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

//밑에 검색기록
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
        .padding(.leading,26)
        .padding(.trailing, 20.0)
        
    }
}

#Preview {
    SearchBarView()
}

// Extension to remove HTML tags from String
extension String {
    func removeHTMLTags() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
