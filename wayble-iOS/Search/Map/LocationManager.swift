//  LocationManager.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/27/25.


import Foundation
import CoreLocation
import Observation


class LocationManager: NSObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    static let shared = LocationManager()

    private var completionHandler: ((CLLocationCoordinate2D?) -> Void)?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
    
    }

    func requestLocation(completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        print("requestLocation 진입")
        self.completionHandler = completion

        let status = manager.authorizationStatus
      

        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()   // 승인되면 아래 콜백에서 시작
        case .authorizedWhenInUse, .authorizedAlways:
            //  캐시 위치가 있으면 즉시 사용
            if let cached = manager.location?.coordinate {
                print(" cached 위치 사용: \(cached.latitude), \(cached.longitude)")
                finish(cached)
            } else {
                print("▶️ startUpdatingLocation() 시작")
                manager.startUpdatingLocation()
            }
        case .denied, .restricted:
            finish(nil)
        @unknown default:
            finish(nil)
        }
    }


    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let st = manager.authorizationStatus
        print("권한 변경: \(st.rawValue) / \(st)")
        if (st == .authorizedWhenInUse || st == .authorizedAlways), completionHandler != nil {
            print("권한 승인됨 → startUpdatingLocation 재시작")
            manager.startUpdatingLocation()
        } else if st == .denied || st == .restricted {
            finish(nil)
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("✅ 위치 업데이트됨 (\(locations.count))")
        finish(locations.last?.coordinate)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let ns = error as NSError
        print("❌ 위치 가져오기 실패: \(error.localizedDescription) (\(ns.domain)#\(ns.code))")
        print("🔍 현재 권한 상태: \(manager.authorizationStatus.rawValue)")

        // ⏳ 자주 오는 일시 오류: locationUnknown → 잠깐 뒤 재시도하고 종료하지 않음
        if ns.domain == kCLErrorDomain as String,
           ns.code == CLError.locationUnknown.rawValue,
           completionHandler != nil {
            print("⏳ locationUnknown → 0.5초 후 재요청")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak manager] in
                manager?.startUpdatingLocation()
            }
            return
        }

        // 그 외엔 종료
        finish(nil)
    }

    private func finish(_ coord: CLLocationCoordinate2D?) {
        if let c = coord {
            print("🎯 전달 좌표: \(c.latitude), \(c.longitude)")
        } else {
            print("🚫 좌표 없음(nil) 전달")
        }
        completionHandler?(coord)
        completionHandler = nil
        manager.stopUpdatingLocation()
        print("⏹️ stopUpdatingLocation()")
    }
}

extension SearchViewModel {
    static let shared = SearchViewModel()
}
