// MARK: PLACEINFO

import Foundation
import Observation



struct WaybleZoneResponse: Codable {
    let data: WaybleZone
}

struct WaybleZone: Codable, Identifiable {
    let id: Int
    let name: String
    let category: String
    let address: String
    let rating: Double
    let reviewCount: Int
    let contactNumber: String
    let imageUrl: String
    let facilities: Facilities
    let businessHours: [String: OpeningHours]
    let photos: [String]
    let latitude: Double
    let longitude: Double

    // JSON 키가 Swift 변수 이름과 다를 때
    enum CodingKeys: String, CodingKey {
        case id = "waybleZoneId"
        case name
        case category
        case address
        case rating
        case reviewCount
        case contactNumber
        case imageUrl
        case facilities
        case businessHours
        case photos
        case latitude
        case longitude
    }
}

struct Facilities: Codable {
    let hasSlope: Bool
    let hasNoDoorStep: Bool
    let hasElevator: Bool
    let hasTableSeat: Bool
    let hasDisabledToilet: Bool
    let floorInfo: String

    enum CodingKeys: String, CodingKey {
        case hasSlope = "hasSlope"
        case hasNoDoorStep = "hasNoDoorStep"
        case hasElevator = "hasElevator"
        case hasTableSeat = "hasTableSeat"
        case hasDisabledToilet = "hasDisabledToilet"
        case floorInfo = "floorInfo"
    }
}


struct OpeningHours: Codable {
    let open: String
    let close: String
}

//MARK: SavedPlaces

struct SavedPlace: Identifiable, Codable {
    let placeID: Int
    let title: String
    let color: String
    let waybleZone: [WaybleZone]
    
    var id: Int { placeID }

    enum CodingKeys: String, CodingKey {
        case placeID = "place_id"
        case title
        case color
        case waybleZone = "wayble_zone"
    }
}



//MARK: REVIEW


struct ReviewListResponse: Codable {
    let data: [Review]
}


struct Review: Identifiable, Codable {
    let id: Int
    let userNickname: String
    let rating: Int
    let content: String
//    let visitDate: Date
    let visitDate: String
    let likes: Int
    let images: [String]

    enum CodingKeys: String, CodingKey {
        case id = "review_id"
        case userNickname = "user_nickname"
        case rating
        case content
        case visitDate = "visit_date"
        case likes
        case images
    }
}

//MARK: TOP 3

struct FavoritesWaybleZoneResponse: Decodable {
    let data: [FavoritesWaybleZone]
}

//테이블 따로 만드신듯
//struct FavoritesWaybleZone: Decodable {
//    let waybleZoneInfo: WaybleZone
//    // visitCount, likes는 UI에서 사용x 무시 가능
//}


struct FavoritesWaybleZone: Decodable {
    let waybleZoneInfo: FavWaybleZoneInfo
}


struct FavWaybleZoneInfo: Decodable, Identifiable {
    let id: Int
    let name: String
    let category: String
    let imageUrl: String?
    let address: String
    let latitude: Double
    let longitude: Double
    let rating: Double
    let reviewCount: Int
    let facilities: Facilities

    enum CodingKeys: String, CodingKey {
        case id = "zoneId"
        case name = "zoneName"
        case category = "zoneType"
        case imageUrl = "thumbnailImageUrl"
        case address
        case latitude
        case longitude
        case rating = "averageRating"
        case reviewCount
        case facilities = "facility"
    }
}
