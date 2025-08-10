//
//  WalkingDataMapper.swift
//  wayble-iOS
//
//  Created by 신민정 on 8/9/25.
//

import Foundation
import NMapsMap
import UIKit

extension WalkingRouteData {
    func toRouteData(
        title: String = "도보 최적경로",
        lineColor: UIColor = .systemBlue
    ) -> RouteData {
        let coords = path.map { NMGLatLng(lat: $0.lat, lng: $0.lng) }

        let distanceString = "\(distance)m"
        let minutes = max(1, duration / 60)
        let timeString = "\(minutes)분"

        let arrivalString: String = {
            let f = ISO8601DateFormatter()
            guard let date = f.date(from: time) else { return "도착 예정 시간" }
            let df = DateFormatter()
            df.locale = Locale(identifier: "ko_KR")
            df.dateFormat = "a h:mm '도착'"
            return df.string(from: date)
        }()

        return RouteData(
            title: title,
            time: timeString,
            arrivalTime: arrivalString,
            distance: distanceString,
            path: coords,
            elevatorPoints: nil,
            wheelchairPoints: nil,
            lineColor: lineColor
        )
    }
}
