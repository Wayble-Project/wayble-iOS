//
//  PlaceResponse.swift
//  wayble-iOS
//
//  Created by 신민정 on 8/18/25.
//

import Foundation

struct PlaceResponse: Decodable {
    let data: String?
    let errorCode: Int?
    let message: String?
}
