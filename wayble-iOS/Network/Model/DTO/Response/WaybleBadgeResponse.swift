//
//  WaybleBadgeResponse.swift
//  wayble-iOS
//
//  Created by 이서현 on 8/15/25.
//

import Foundation

// MARK: - Response Wrapper
/// 성공 시:
/// {
///   "data": {
///     "waybleZoneInfo": { ... },
///     "distance": 0.0
///   }
/// }
///
/// 검색 결과 없음 시:
/// { "data": null }
///
/// 실패 시(예: 400):
/// { "errorCode": 400, "message": "..." }


struct WaybleBadgeResponse: Decodable {
    let errorCode: Int?
    let message: String?
    let data: WaybleBadgeData?

    /// 편의 프로퍼티
    var isSuccess: Bool { data != nil && errorCode == nil }
}

// MARK: - Data Payload
struct WaybleBadgeData: Decodable {
    let waybleZoneInfo: FavWaybleZoneInfo
    let distance: Double
}
