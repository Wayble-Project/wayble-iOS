//
//  TransitRequest.swift
//  wayble-iOS
//
//  Created by 신민정 on 8/14/25.
//

import Foundation

struct TransitRequest: Encodable {
    let origin: PlacePoint
    let destination: PlacePoint
    let cursor: Int?
    let size: Int

    struct PlacePoint: Encodable {
        let name: String
        let latitude: Double
        let longitude: Double
    }
}
