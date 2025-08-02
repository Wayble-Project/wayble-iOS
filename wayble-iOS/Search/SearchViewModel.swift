//
//  SearchViewModel.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/11/25.
//

//비동기 async

import Foundation
import Observation
import CoreLocation

enum PlaceEntryType {
    case departure
    case destination
}

@Observable
class SearchViewModel {


    var waybleZones: [WaybleZone] = []
    var entryType: PlaceEntryType  = .departure

    func setWaybleZones(_ zones: [WaybleZone]) {
        self.waybleZones = zones
    }
    var hasUserSetDeparture: Bool = false
    var transportation = TransportationModel()
    var selectedPlace: PlaceModel = PlaceModel()
    var searchText: String = ""
    var searchModels: [SearchModel] = [
        SearchModel(icon: "search", title: "음식점", date: "06.27"),
        SearchModel(icon: "location", title: "카페 아임히어", date: "06.11")
    ]
    var suggestionKeywords: [String] = [
        "아임히어", "아임히드라", "아임히알루룬산"
    ]
    
    var suggestions: [PlaceModel] = []

    private var lastRequestedCoordinate: CLLocationCoordinate2D?
    
    //  연관검색 , 검색 api 연결
    func fetchNaverSuggestions(for query: String) async throws {
        guard !query.isEmpty else {
            self.suggestions = []
            return
        }

        let clientID = Bundle.main.object(forInfoDictionaryKey: "NAVER_CLIENT_ID") as? String ?? ""
        let clientSecret = Bundle.main.object(forInfoDictionaryKey: "NAVER_CLIENT_SECRET") as? String ?? ""
        let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://openapi.naver.com/v1/search/local.json?query=\(encodedQuery)&display=5&output=json"
        guard let url = URL(string: urlString) else {
            print(" URL 생성 실패")
            return
        }
        
        print("요청 URL: \(url)")

        var request = URLRequest(url: url)
        request.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let (data, _) = try await URLSession.shared.data(for: request)

        print("응답 JSON: \(String(data: data, encoding: .utf8) ?? "읽기 실패")")

        let decoded = try JSONDecoder().decode(NaverPlaceResponse.self, from: data)
        DispatchQueue.main.async {
            print("받은 결과 개수: \(decoded.items?.count ?? 0)")
            self.suggestions = decoded.items ?? []
        }
    }

    // 연관검색 결과에서 도로명 주소로 장소 매칭
    func matchPlaceFromSuggestions(using roadName: String) {
        if let matchedPlace = suggestions.first(where: { $0.roadAddress.contains(roadName) }) {
            print("매칭된 장소: \(matchedPlace.title)")
            self.selectedPlace = matchedPlace
        } else {
            print("일치하는 장소 없음")
        }
    }

    // 중심 좌표 기준 가장 가까운 장소 하나 매칭
    func matchNearestPlace(to center: CLLocationCoordinate2D) {
        guard !suggestions.isEmpty else {
            print(" 장소 리스트 비어있음")
            return
        }

        let nearest = suggestions.min(by: {
            let loc1 = CLLocation(latitude: $0.latitude, longitude: $0.longitude)
            let loc2 = CLLocation(latitude: $1.latitude, longitude: $1.longitude)
            let target = CLLocation(latitude: center.latitude, longitude: center.longitude)
            return loc1.distance(from: target) < loc2.distance(from: target)
        })

        if let place = nearest {
            print(" 가장 가까운 장소: \(place.title)")
            self.selectedPlace = place
        } else {
            print(" 가까운 장소 못 찾음")
        }
    }

    //  역지오코딩 함수 - 바깥으로 뺐음! / 지도 api 사용
    func callReverseGeocodeAPI(lat: Double, lng: Double) async throws -> (String, String) {
        let mapClientID = Bundle.main.object(forInfoDictionaryKey: "NMFNcpKeyId") as? String ?? ""
        let mapClientSecret = Bundle.main.object(forInfoDictionaryKey: "NMFNcpKeySecret") as? String ?? ""

        let coord = "\(lng),\(lat)"
        let urlString = "https://maps.apigw.ntruss.com/map-reversegeocode/v2/gc?coords=\(lng),\(lat)&output=json&orders=legalcode,admcode,addr,roadaddr"
        guard let url = URL(string: urlString) else {
            print("역지오코딩 URL 생성 실패")
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.addValue(mapClientID, forHTTPHeaderField: "X-NCP-APIGW-API-KEY-ID")
        request.addValue(mapClientSecret, forHTTPHeaderField: "X-NCP-APIGW-API-KEY")
        request.addValue("application/json", forHTTPHeaderField: "Accept")

        let (data, _) = try await URLSession.shared.data(for: request)
        print("🛰️ 응답 JSON: \(String(data: data, encoding: .utf8) ?? "no data")")

        let decoded = try JSONDecoder().decode(NaverReverseGeoResponse.self, from: data)
        let results = decoded.results

        
        var fullAddress: String?
        var roadAddress: String?

        for result in results {
            if fullAddress == nil,
               let area1 = result.region.area1.name as String?,
               let area2 = result.region.area2.name as String?,
               let area3 = result.region.area3.name as String? {
                fullAddress = "\(area1) \(area2) \(area3)"
            }

            if roadAddress == nil,
               let roadName = result.land?.name,
               let number1 = result.land?.number1 {
                roadAddress = "\(roadName) \(number1)"
            }

            if fullAddress != nil, roadAddress != nil {
                break
            }
        }

        if let full = fullAddress {
            return (full, roadAddress ?? "")
        } else {
            print(" 역지오코딩 결과 부족")
            throw NSError(domain: "ReverseGeocodeError", code: -1, userInfo: nil)
        }
    }
    
    func fetchKakaoNearbyPlace(lat: Double, lng: Double, address: String) async throws -> PlaceModel? {
        let kakaoKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_REST_API_KEY") as? String ?? ""
        let query = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlStr = "https://dapi.kakao.com/v2/local/search/keyword.json?query=\(query)&x=\(lng)&y=\(lat)&radius=50&sort=distance"

        guard let url = URL(string: urlStr) else {
            return nil
        }

        var request = URLRequest(url: url)
        request.addValue("KakaoAK \(kakaoKey)", forHTTPHeaderField: "Authorization")

        let (data, _) = try await URLSession.shared.data(for: request)

        do {
            let decoded = try JSONDecoder().decode(KakaoPlaceResponse.self, from: data)
            if let first = decoded.documents.first {
                let place = PlaceModel(
                    title: first.place_name,
                    roadAddress: first.road_address_name,
                    x: first.x,
                    y: first.y,
                    category: first.category_name
                )
                return place
            } else {
                return nil
            }
        } catch {
            print("카카오 디코딩 오류: \(error)")
            return nil
        }
    }
    //출발 버튼 누르면 값 갱신
    func setPlace(_ place: PlaceModel, for entryType: EntryType) {
        switch entryType {
        case .departure:
            transportation.departure = place.roadAddress
            hasUserSetDeparture = true
        case .destination:
            transportation.destination = place.roadAddress
            if !hasUserSetDeparture {
                Task {
                    do {
                        guard let coordinate = LocationManager.shared.currentCoordinate else { return }
                        let (fullAddress, _) = try await self.callReverseGeocodeAPI(lat: coordinate.latitude, lng: coordinate.longitude)
                        DispatchQueue.main.async {
                            self.transportation.departure = fullAddress
                        }
                    } catch {
                        print("현재 위치 기반 출발지 설정 실패: \(error)")
                    }
                }
            }
        }
    }
    // 중심 좌표가 바뀌었을 때 → 역지오코딩 → 카카오 장소 검색 → selectedPlace 세팅
    func handleCenterChanged(lat: Double, lng: Double) {
        Task {
            let currentCoord = CLLocationCoordinate2D(latitude: lat, longitude: lng)

            // 이미 비슷한 좌표로 요청했는지 확인 (10미터 이내면 중복으로 간주)
            if let lastCoord = lastRequestedCoordinate {
                let distance = CLLocation(latitude: lat, longitude: lng).distance(from: CLLocation(latitude: lastCoord.latitude, longitude: lastCoord.longitude))
                if distance < 10 {
                    print("너무 가까운 위치 - 중복 호출 방지됨 (\(distance)m)")
                    return
                }
            }

            lastRequestedCoordinate = currentCoord
            print("중심 좌표 변경됨: (\(lat), \(lng))")

            do {
                // 1. 네이버 역지오코딩 → 도로명 주소 받아오기
                let (fullAddress, roadAddress) = try await callReverseGeocodeAPI(lat: lat, lng: lng)
                print("역지오코딩 주소: \(fullAddress)")

                // 2. 카카오 장소 검색
                if let place = try await fetchKakaoNearbyPlace(lat: lat, lng: lng, address: roadAddress) {
                    DispatchQueue.main.async {
                        self.selectedPlace = place
                        print("최종 선택된 장소 (카카오): \(place.title)")
                    }
                } else {
                    let dummy = PlaceModel(
                        title: "이 위치의 장소",
                        roadAddress: roadAddress,
                        x: "\(lng)",
                        y: "\(lat)",
                        category: "기타"
                    )
                    DispatchQueue.main.async {
                        self.selectedPlace = dummy
                        print("최종 선택된 장소 (더미): \(dummy.title)")
                    }
                }
            } catch {
                print("handleCenterChanged 에러: \(error)")
            }
        }
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
