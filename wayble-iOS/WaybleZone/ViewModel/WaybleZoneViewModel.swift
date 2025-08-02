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
    
    var id: String { self.rawValue } //.id(\.self) 이거 안 써도 됨
    
    var iconName: String {
        switch self {
        case .hasNoDoorStep: return "door"
        case .floorInfo: return ""
        case .kindStaff: return ""
        case .hasTableSeat: return "table"
        case .hasDisabledToilet: return "chair02"
        case .hasSlope: return "chair01"
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
            hasElevator: false, // 선택 항목에 없음
            hasTableSeat: selected.contains(.hasTableSeat),
            hasDisabledToilet: selected.contains(.hasDisabledToilet),
            floorInfo: selected.contains(.floorInfo) ? selectedFloorInfo : ""
        )
    }
}



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
    
    //제거 예정 다른 뷰모델로
    func fetchFavoritesZones(district: String = "마포구") async {
            do {
                self.FavoritesZones = try await FavoritesZonesService.fetchFavoritesZones(in: district)
            } catch {
                print("Error fetching Favorites zones: \(error.localizedDescription)")
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
    
  //  var favoritesTop3: [FavWaybleZoneInfo] = []

       private let FavoritesZonesService: any FavoritesWaybleZoneServiceProtocol

       init(FavoritesZonesService: any FavoritesWaybleZoneServiceProtocol = FavoritesWaybleZoneService()) {
           self.FavoritesZonesService = FavoritesZonesService
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
                let result = try await FavoritesZonesService.fetchFavoritesZones(in: "마포구")
                self.top3Zones = result.prefix(3).map { $0.waybleZoneInfo }
            case .search:
                //TODO: 검색순
                self.top3Zones = []
            }
        } catch {
            print("Top3 fetch Error: \(error)")
        }
    }
}
