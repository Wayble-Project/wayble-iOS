//
//  HomeViewModel.swift
//  wayble-iOS
//
//  Created by 이서현 on 8/12/25.
//

import Foundation
import CoreLocation

@Observable
class HomeViewModel {
    var zone: FavWaybleZoneInfo? = nil
    var isLoading: Bool = false
    var errorMessage: String? = nil
    var hasLoadedZone: Bool = false
    var lastCoordinate: CLLocationCoordinate2D? = nil

    func fetchZone(size: Int = 1) async {
        if isLoading { return }
        isLoading = true
        defer { isLoading = false }

        // 현재 위치 받아오기 (await 버전, 2초 타임아웃 적용)
        var coordinate: CLLocationCoordinate2D? = await withCheckedContinuation { continuation in
            var resumed = false
            let timeout = DispatchWorkItem {
                if !resumed {
                    resumed = true
                    print("⏱️ 위치 타임아웃: 기본 좌표로 진행")
                    continuation.resume(returning: nil)
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: timeout)

            LocationManager.shared.requestLocation { coord in
                if !resumed {
                    timeout.cancel()
                    resumed = true
                    continuation.resume(returning: coord)
                }
            }
        }

        //let finalCoordinate = coordinate ?? CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)
        let finalCoordinate = coordinate ?? CLLocationCoordinate2D(latitude: 37.4738, longitude: 127.0067)
        
        /*
        if finalCoordinate.latitude == 37.5665 && finalCoordinate.longitude == 126.9780 {
            print("ℹ️ 기본값 위치 사용 : \(finalCoordinate.latitude), \(finalCoordinate.longitude)")
        }
         */
        if finalCoordinate.latitude == 37.4738 && finalCoordinate.longitude == 127.0067 {
            print("ℹ️ 기본값 위치 사용 (예술의전당): \(finalCoordinate.latitude), \(finalCoordinate.longitude)")
        }

        // Skip fetch if we've already loaded for effectively the same coordinate
        if hasLoadedZone, let last = lastCoordinate, HomeViewModel.approxEqual(last, finalCoordinate) {
            print("↩️ 동일 좌표로 이미 로드됨 — 네트워크 요청 생략")
            return
        }

        do {
            let response = try await HomeWaybleZoneService()
                .getHomeWaybleZone(latitude: finalCoordinate.latitude,
                                   longitude: finalCoordinate.longitude,
                                   size: size)
            print("📦 items: \(response.data.count)")
            if let info = response.data.first?.waybleZoneInfo {
                print("🆔 id: \(info.id)")
                print("🏷️ name: \(info.name)")
                print("📍 lat/lng: \(info.latitude), \(info.longitude)")
                print("⭐️ rating: \(info.rating)  reviews: \(info.reviewCount)")
                dump(info.facilities, name: "🏗️ facilities", maxDepth: 2)
            }
            await MainActor.run {
                self.zone = response.data.first?.waybleZoneInfo
                self.errorMessage = nil
                self.lastCoordinate = finalCoordinate
                self.hasLoadedZone = true
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
            }
            print("❌ 추천존 조회 실패: \(error.localizedDescription)")
        }
    }
    
    static func approxEqual(_ a: CLLocationCoordinate2D, _ b: CLLocationCoordinate2D, eps: Double = 1e-5) -> Bool {
        abs(a.latitude - b.latitude) < eps && abs(a.longitude - b.longitude) < eps
    }
}
