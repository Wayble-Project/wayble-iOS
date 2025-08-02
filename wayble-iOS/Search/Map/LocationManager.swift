//
//  LocationManager.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/27/25.
//

import SwiftUI
import CoreLocation

// 현위치 가져오기

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var currentCoordinate: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.first?.coordinate else { return }
        currentCoordinate = coordinate
        manager.stopUpdatingLocation()
    }
}

