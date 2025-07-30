//
//  KakaoPlaceResponse.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/29/25.
//

import SwiftUI
import Foundation

// MARK: - Kakao 장소 응답 모델

struct KakaoPlaceResponse: Decodable {
    let documents: [KakaoPlace]
}

// MARK: - Kakao 장소 모델

struct KakaoPlace: Decodable {
    let place_name: String
    let road_address_name: String
    let x: String
    let y: String
    let category_name: String
}
