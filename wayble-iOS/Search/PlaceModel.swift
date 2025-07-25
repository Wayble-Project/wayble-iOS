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
    let places: [PlaceModel]

    enum CodingKeys: String, CodingKey {
        case places = "items"
    }
}

struct PlaceModel: Codable, Identifiable, Hashable {
    let id = UUID()
    let title: String
    let roadAddress: String
    let x: String?
    let y: String?
    let category: String
    let isWaybleZone: Bool? //웨이블존 뱃지

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
