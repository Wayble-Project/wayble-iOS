//
//  WaybleZoneAPIData.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/30/25.
//

import Foundation

struct WaybleZoneAPIResponse: Codable {
    let data: [WaybleZoneAPIData]
}

struct WaybleZoneAPIData: Codable {
    let waybleZoneID: Int
    let name: String
    let category: String
    let address: String
    let rating: Double
    let reviewCount: Int
    let imageURL: String?
    let contactNumber: String?
    let facilities: Facility?
    
    enum CodingKeys: String, CodingKey {
        case waybleZoneID = "wayble_zone_id"
        case name
        case category
        case address
        case rating
        case reviewCount = "review_count"
        case imageURL = "image_url"
        case contactNumber = "contact_number"
        case facilities
    }
}

struct Facility: Codable {
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
