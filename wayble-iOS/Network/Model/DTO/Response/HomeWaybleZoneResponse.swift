//
//  HomeWaybleZoneResponse.swift
//  wayble-iOS
//
//  Created by 이서현 on 8/12/25.
//


import Foundation

// MARK: - Response root
struct HomeWaybleZoneResponse: Decodable {
    let data: [HomeWaybleZoneItem]
}

struct ErrorResponse: Codable {
    let errorCode: Int
    let message: String
}

// MARK: - Item
struct HomeWaybleZoneItem: Decodable, Identifiable {
    let waybleZoneInfo: FavWaybleZoneInfo
    let distanceScore: Double
    let similarityScore: Double
    let recencyScore: Double
    let totalScore: Double

    // Use the nested zoneId as a stable id for SwiftUI lists
    var id: Int { waybleZoneInfo.id }
}

// MARK: - WaybleZoneModel에 있는데 보기 힘들어서 가져왔따

/* 
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
 
 */
