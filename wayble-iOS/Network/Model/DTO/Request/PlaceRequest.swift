//
//  PlaceRequest.swift
//  wayble-iOS
//
//  Created by 신민정 on 8/18/25.
//

import Foundation

struct PlaceRequest: Encodable {
    let requests: [RequestItem]

    struct RequestItem: Encodable {
        let name: String
        let address: Address
    }
    
    struct Address: Encodable {
        let state: String
        let city: String
        let district: String
        let streetAddress: String
        let detailAddress: String
        let latitude: Double
        let longitude: Double
    }

}

