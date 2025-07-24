//
//  SearchViewModel.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/11/25.
//

import SwiftUI
import Observation



@Observable
class SearchViewModel {

    var searchText: String = ""
    var searchModels: [SearchModel] = [
        SearchModel(icon: "search", title: "음식점", date: "06.27"),
        SearchModel(icon: "location", title: "카페 아임히어", date: "06.11")
    ]
    var suggestionKeywords: [String] = [
        "아임히어", "아임히드라", "아임히알루룬산"
    ] // 자동완성 뷰모델 
    
    var suggestions: [Place] = []
    
// 연관검색 구현 뷰모델
        func fetchNaverSuggestions(for query: String) {
            guard !query.isEmpty else {
                self.suggestions = []
                return
            }
            
            
            let clientID = Bundle.main.object(forInfoDictionaryKey: "NAVER_CLIENT_ID") as? String ?? ""
            let clientSecret = Bundle.main.object(forInfoDictionaryKey: "NAVER_CLIENT_SECRET") as? String ?? ""
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let urlString = "https://openapi.naver.com/v1/search/local.json?query=\(encodedQuery)&display=5"
            guard let url = URL(string: urlString) else {
                print("❌ URL 생성 실패")
                return
            }

            var request = URLRequest(url: url)
            request.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
            request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
            request.addValue("application/json", forHTTPHeaderField: "Accept")

            URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    print("요청 에러: \(error)")
                    return
                }
                
                if let data = data,
                   let jsonString = String(data: data, encoding: .utf8) {
                    print("📦 응답 JSON:\n\(jsonString)")
                }

                guard let data = data else { return }

                do {
                    let decoded = try JSONDecoder().decode(NaverPlaceResponse.self, from: data)
                    DispatchQueue.main.async {
                        print("받은 결과 개수: \(decoded.places.count)")
                        self.suggestions = decoded.places
                    }
                } catch {
                    print("디코딩 에러: \(error)")
                }
            }.resume()
        }
}

// 연관검색용 모델 

struct NaverPlaceResponse: Codable {
    let places: [Place]

    enum CodingKeys: String, CodingKey {
        case places = "items"
    }
}

struct Place: Codable, Identifiable {
    let id = UUID()
    let title: String
    let roadAddress: String
    let x: String?     // ✅ 옵셔널로 바꿈
    let y: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case roadAddress
        case x = "mapx"
        case y = "mapy"
    }
}
