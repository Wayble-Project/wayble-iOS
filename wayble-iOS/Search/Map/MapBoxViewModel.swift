//
//  MapBoxViewModel.swift
//  wayble-iOS
//
//  Created by 이서현 on 8/15/25.
//

import Foundation
import Moya

@MainActor
final class MapBoxViewModel: ObservableObject {
    
    
    func hasWaybleBadge(latitude: Double, longitude: Double, zoneName: String) async -> Bool {
        do {
            let response = try await WaybleBadgeService().getWaybleBadge(latitude: latitude, longitude: longitude, zoneName: zoneName)
            return response.data != nil
        } catch {
            print("⚠️ WaybleBadge 조회 실패: \(error)")
            return false
        }
    }
}
