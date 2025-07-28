//
//  PlaceModel.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/25/25.
//

import SwiftUI
import Foundation

//연관검색
struct NaverPlaceResponse: Codable {
    let total: Int
    let display: Int
    let places: [PlaceModel]

    enum CodingKeys: String, CodingKey {
        case total
        case display
        case places = "items"
    }
}

struct PlaceModel: Codable, Identifiable, Hashable {
    let id = UUID()
    var title: String = ""
    var roadAddress: String = ""
    var x: String? = nil
    var y: String? = nil
    var category: String = ""
    var isWaybleZone: Bool? = false

    enum CodingKeys: String, CodingKey {
        case title
        case roadAddress
        case x = "mapx"
        case y = "mapy"
        case category
        case isWaybleZone
    }

    var primaryCategory: String {
        return category.components(separatedBy: ">").first ?? ""
    }
}
