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

    // JSON 키가 Swift 변수 이름과 다를 때
    enum CodingKeys: String, CodingKey {
        case id = "wayble_zone_id"
        case name
        case category
        case address
        case rating
        case reviewCount = "review_count"
        case contactNumber = "contact_number"
        case imageUrl = "image_url"
        case facilities
        case businessHours = "business_hours"
        case photos
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
        case hasSlope = "has_slope"
        case hasNoDoorStep = "has_no_door_step"
        case hasElevator = "has_elevator"
        case hasTableSeat = "has_table_seat"
        case hasDisabledToilet = "has_disabled_toilet"
        case floorInfo = "floor_info"
    }
}


struct OpeningHours: Codable {
    let open: String
    let close: String
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
    let visitDate: Date
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

