//
//  SearchViewModel.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/11/25.
//

import Foundation
import Observation

@Observable
class SearchViewModel {
    var selectedPlace: PlaceModel? = nil
    var searchText: String = ""
    var searchModels: [SearchModel] = [
        SearchModel(icon: "search", title: "음식점", date: "06.27"),
        SearchModel(icon: "location", title: "카페 아임히어", date: "06.11")
    ]
    var suggestionKeywords: [String] = [
        "아임히어", "아임히드라", "아임히알루룬산"
    ]
    
    var suggestions: [PlaceModel] = []
    
    // ✅ 연관검색
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
        request.addValue(clientID, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        request.addValue(clientSecret, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
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

    // ✅ 연관검색 결과에서 도로명 주소로 장소 매칭
    func matchPlaceFromSuggestions(using roadName: String) {
        if let matchedPlace = suggestions.first(where: { $0.roadAddress.contains(roadName) }) {
            print("✅ 매칭된 장소: \(matchedPlace.title)")
            self.selectedPlace = matchedPlace
        } else {
            print("❌ 일치하는 장소 없음")
        }
    }

    // ✅ 역지오코딩 함수 - 바깥으로 뺐음!
    func callReverseGeocodeAPI(lat: Double, lng: Double, completion: @escaping (String) -> Void) {
        let clientID = Bundle.main.object(forInfoDictionaryKey: "NMFNcpKeyId") as? String ?? ""
        let clientSecret = Bundle.main.object(forInfoDictionaryKey: "NMFNcpKeySecret") as? String ?? ""

        let coord = "\(lng),\(lat)"
        let urlString = "https://maps.apigw.ntruss.com/map-reversegeocode/v2/gc?coords=\(lng),\(lat)&output=json&orders=roadaddr"

        guard let url = URL(string: urlString) else {
            print("❌ 역지오코딩 URL 생성 실패")
            return
        }

        var request = URLRequest(url: url)
        request.addValue(clientID, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        request.addValue(clientSecret, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print("❌ 역지오코딩 요청 에러: \(error)")
                return
            }

            guard let data = data else { return }
            print("🛰️ 응답 JSON: \(String(data: data, encoding: .utf8) ?? "no data")")

            do {
                let decoded = try JSONDecoder().decode(NaverReverseGeoResponse.self, from: data)

                let results = decoded.results
                if let land = results.first?.land,
                   let name = land.name {
                    DispatchQueue.main.async {
                        completion(name)
                    }
                } else {
                    print("❌ 역지오코딩 결과 없음!")
                }
            } catch {
                print("❌ 역지오코딩 디코딩 에러: \(error)")
            }
        }.resume()
    }
}


// MARK: - Reverse Geocode Models

struct NaverReverseGeoResponse: Decodable {
    let results: [ReverseGeoResult]
}

struct ReverseGeoResult: Decodable {
    let name: String
    let region: Region
    let land: ReverseGeoLand?
}

struct Region: Decodable {
    let area1: Area
    let area2: Area
    let area3: Area
    let area4: Area
}

struct Area: Decodable {
    let name: String
}

struct ReverseGeoLand: Decodable {
    let name: String?
    let number1: String?
    let number2: String?
}
