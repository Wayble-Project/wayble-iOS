//
//  PlaceModel.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/25/25.
//

import SwiftUI
import Foundation
import CoreLocation


//연관검색
struct NaverPlaceResponse: Codable {
    let total: Int?
    let display: Int?
    let items: [PlaceModel]?

    enum CodingKeys: String, CodingKey {
        case total
        case display
        case items
    }
}

struct PlaceModel: Codable, Identifiable, Hashable,Equatable {
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

extension PlaceModel {
    var latitude: Double {
        if let yValue = Double(y ?? "") {
            return yValue > 1000 ? yValue / 1e7 : yValue
        }
        return 0.0
    }

    var longitude: Double {
        if let xValue = Double(x ?? "") {
            return xValue > 1000 ? xValue / 1e7 : xValue
        }
        return 0.0
    }
}
