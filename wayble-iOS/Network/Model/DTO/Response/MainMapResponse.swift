//
//  MainMapResponse.swift
//  wayble-iOS
//
//  Created by 이서현 on 8/12/25.
//

import Foundation


struct MainMapResponse: Codable {
    let data: [HomeFacility] ///배열 형태로
}

//MARK: - 위도, 경도, 시설 종류 담은 데이터
struct HomeFacility: Codable {
    let latitude: Double
    let longitude: Double
    let facilityType: String
}
