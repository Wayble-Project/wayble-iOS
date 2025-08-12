import SwiftUI
import Observation

// WaybleZone 상세페이지
enum FacilityOption: String, CaseIterable, Identifiable {
    case hasNoDoorStep = "문턱 없음"
    case floorInfo = "1F 1층"
    case kindStaff = "직원이 친절해요"
    case hasTableSeat = "테이블석"
    case hasDisabledToilet = "장애인 화장실"
    case hasSlope = "경사로"
    case hasElevator = "엘리베이터"
    
    var id: String { self.rawValue } //.id(\.self) 이거 안 써도 됨
    
    var iconName: String {
        switch self {
        case .hasNoDoorStep: return "door"
        case .floorInfo: return ""
        case .kindStaff: return ""
        case .hasTableSeat: return "table"
        case .hasDisabledToilet: return "chair02"
        case .hasSlope: return "chair01"
        case .hasElevator : return "lift"
        }
    }
}



@Observable
class FacilitySelectionViewModel {
    var selected: Set<FacilityOption> = []
    var selectedFloorInfo: String = "1F 1층"
    
    func toggle(_ option: FacilityOption) {
        if selected.contains(option) {
            selected.remove(option)
        } else {
            selected.insert(option)
        }
    }
    
    var facilities: Facilities {
        Facilities(
            hasSlope: selected.contains(.hasSlope),
            hasNoDoorStep: selected.contains(.hasNoDoorStep),
            hasElevator: selected.contains(.hasElevator),
            hasTableSeat: selected.contains(.hasTableSeat),
            hasDisabledToilet: selected.contains(.hasDisabledToilet),
            floorInfo: selected.contains(.floorInfo) ? selectedFloorInfo : ""
        )
    }
    //mock 데이터 넣어보기용 함수
    //api 연결시 삭제
    func loadMockData() {
        let mock = mockWaybleZoneResponse.data.facilities
        
        if mock.hasSlope { selected.insert(.hasSlope) }
        if mock.hasNoDoorStep { selected.insert(.hasNoDoorStep) }
        if mock.hasElevator { selected.insert(.hasElevator) }
        if mock.hasTableSeat { selected.insert(.hasTableSeat) }
        if mock.hasDisabledToilet { selected.insert(.hasDisabledToilet) }
        if !mock.floorInfo.isEmpty {
            selected.insert(.floorInfo)
            selectedFloorInfo = mock.floorInfo
        }
    }
    var mockZone: WaybleZone {
        return mockWaybleZoneResponse.data
    }
}




//@Observable
//final class PlaceDetailViewModel2 {
//    var waybleZone: WaybleZone? = nil
//
//    //    func getPlaceDetail() async throws -> WaybleZone {
//    //        let url = URL(string: "")!
//    //        let (data, _) = try await URLSession.shared.data(from: url)
//    //        let wrapper = try JSONDecoder().decode(WaybleZoneResponse.self, from: data)
//    //        return wrapper.items[0]
//    //    }
//
//    func fetchPlaceDetail() async {
//        do {
//            self.waybleZone = try await getPlaceDetail()
//        } catch {
//            print("Error fetching detail: \(error.localizedDescription)")
//        }
//    }
//
//    func getPlaceDetail() async throws -> WaybleZone {
//        guard let url = URL(string: "http://localhost:8080/wayble-zone?city=일산&category=카페") else {
//            throw URLError(.badURL)
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.setValue("Bearer valid_jwt_token", forHTTPHeaderField: "Authorization")
//
//        let (data, response) = try await URLSession.shared.data(for: request)
//
//        if let httpResponse = response as? HTTPURLResponse {
//            guard (200..<300).contains(httpResponse.statusCode) else {
//                throw NSError(domain: "HTTP Error", code: httpResponse.statusCode)
//            }
//        }
//
//        let wrapper = try JSONDecoder().decode(WaybleZoneResponse.self, from: data)
//        return wrapper.data
//    }
//
//}


@Observable
@MainActor
final class PlaceDetailViewModel {
    var waybleZone: WaybleZone? = nil
    var reviews: [Review] = []
    var FavoritesZones: [FavoritesWaybleZone] = []
    //var isLoadingReviews: Bool = false
    //var reviewErrorMessage: String? = nil
    
    private let zoneService: any WaybleZoneServiceProtocol
    private let FavoritesZonesService: any FavoritesWaybleZoneServiceProtocol
    private let reviewService: any ReviewServiceProtocol
    
    init(zoneService: any WaybleZoneServiceProtocol = WaybleZoneService(),
         reviewService: any ReviewServiceProtocol = ReviewService(),
         FavoritesZonesService: any FavoritesWaybleZoneServiceProtocol = FavoritesWaybleZoneService()
    ) {
        self.zoneService = zoneService
        self.reviewService = reviewService
        self.FavoritesZonesService = FavoritesZonesService
    }
    
    func fetchPlaceDetail(city: String = "일산", category: String = "카페") async {
        do {
            self.waybleZone = try await zoneService.fetchPlaceDetail(city: city, category: category)
        } catch {
            print("Error fetching detail: \(error.localizedDescription)")
        }
    }
    
    
    func fetchReviews(zoneID: Int, sort: ReviewSort = .latest) async {
        //isLoadingReviews = true
        //defer { isLoadingReviews = false }
        
        do {
            self.reviews = try await reviewService.fetchReviews(for: zoneID, sort: sort)
        } catch {
            //self.reviewErrorMessage = error.localizedDescription
            print("Error fetching Reviews: \(error.localizedDescription)")
        }
    }
    
}




@Observable
final class TopPlaceViewModel {
    enum Category: String, CaseIterable, Identifiable {
        case favorite = "즐겨찾기 순"
        case search = "검색순"
        var id: Self { self }
    }
    
    //TODO: 디폴트 현재위치로 수정하기
    @ObservationIgnored
    @AppStorage("selectedDong") private var selectedDong: String = "효창동"
    
    private let FavoritesZonesService: any FavoritesWaybleZoneServiceProtocol
    private let searchRankService: any SearchRankWaybleZoneServiceProtocol
    
    init(FavoritesZonesService: any FavoritesWaybleZoneServiceProtocol = FavoritesWaybleZoneService(),
         searchRankService: any SearchRankWaybleZoneServiceProtocol = SearchRankWaybleZoneService()
    ) {
        self.FavoritesZonesService = FavoritesZonesService
        self.searchRankService = searchRankService
    }
    
    var selected: Category = .favorite {
        willSet {
            Task { await fetchTop3(for: newValue) }
        }
    }
    
    var top3Zones: [FavWaybleZoneInfo] = []
    
    func fetchTop3(for category: Category) async {
        do {
            switch category {
            case .favorite:
                let result = try await FavoritesZonesService.fetchFavoritesZones(in: selectedDong)
                self.top3Zones = result.prefix(3).map { $0.waybleZoneInfo }
            case .search:
                let result = try await searchRankService.fetchTopSearchedZones(in: selectedDong)
                self.top3Zones = result.prefix(3).map { $0.waybleZoneInfo }
            }
        } catch {
            print("Top3 fetch Error: \(error)")
            self.top3Zones = []
        }
    }
}
