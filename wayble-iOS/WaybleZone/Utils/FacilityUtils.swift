import Foundation

enum FacilityUtils {
    
    struct FacilityItem {
        let icon: String
        let label: String
        let isAvailable: Bool
    }
    

    
    static func makeCafeItems(from category: PlaceCategory) -> [FacilityItem] {
        return [
            .init(icon: "cafe", label: "카페", isAvailable: PlaceCategory.cafe.rawValue == "CAFE"),
            .init(icon: "food", label: "음식점", isAvailable: PlaceCategory.restaurant.rawValue == "RESTAURANT")
        ]
    }
    
    static func makeFacilityItems(from facilities: Facilities) -> [FacilityItem] {
        return [
            .init(icon: "chair01", label: "경사로", isAvailable: facilities.hasSlope),
            .init(icon: "chair02", label: "장애인 화장실", isAvailable: facilities.hasDisabledToilet),
            .init(icon: "table", label: "테이블석", isAvailable: facilities.hasTableSeat),
            .init(icon: "door", label: "문턱 없음", isAvailable: facilities.hasNoDoorStep),
            .init(icon: "1F", label: facilities.floorInfo, isAvailable: facilities.floorInfo == "1층"),
            .init(icon: "lift", label: "엘리베이터", isAvailable: facilities.hasElevator)
        ]
    }
    
    static func cardFacilityItems(from f: Facilities) -> [FacilityItem] {
        return [
            .init(icon: "chair01", label: "경사로", isAvailable: f.hasSlope),
            .init(icon: "door", label: "문턱 없음", isAvailable: f.hasNoDoorStep),
            .init(icon: "elevator", label: "엘리베이터", isAvailable: f.hasElevator),
            .init(icon: "table", label: "테이블석", isAvailable: f.hasTableSeat),
            .init(icon: "chair02", label: "장애인 화장실", isAvailable: f.hasDisabledToilet)
        ]
    }

}
