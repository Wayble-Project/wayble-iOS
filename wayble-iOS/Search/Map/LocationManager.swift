//  LocationManager.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/27/25.


import Foundation
import CoreLocation
import Observation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    var currentCoordinate: CLLocationCoordinate2D?
    static let shared = LocationManager()
    var completionHandler: ((CLLocationCoordinate2D?) -> Void)?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func requestLocation(completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        print("🟡 requestLocation 진입") // 이거 꼭 추가
        self.completionHandler = completion

        let status = manager.authorizationStatus
        print("🔍 권한 상태: \(status.rawValue)")

        if status == .notDetermined {
            manager.requestWhenInUseAuthorization()
        } else if status == .authorizedWhenInUse || status == .authorizedAlways {
            manager.requestLocation()
        } else {
            print("❌ 위치 권한 없음 또는 거부됨")
            completionHandler?(nil)
            completionHandler = nil
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("✅ 위치 업데이트됨")
        guard let coordinate = locations.last?.coordinate else { return }
        currentCoordinate = coordinate
        completionHandler?(coordinate)
        completionHandler = nil
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ 위치 가져오기 실패: \(error.localizedDescription)")
        print("🔍 현재 권한 상태: \(manager.authorizationStatus.rawValue)")
    }
    


}

extension SearchViewModel {
    static let shared = SearchViewModel()
}
