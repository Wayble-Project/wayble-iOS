//
//  WalkingDataMapper.swift
//  wayble-iOS
//
//  Created by 신민정 on 8/9/25.
//

import Foundation
import NMapsMap
import UIKit


extension WalkingData {
    
    var hasPolyline: Bool {
           let count = steps.reduce(0) { partial, step in
               partial
               + (step.coordinate == nil ? 0 : 1)
               + (step.coordinates?.count ?? 0)
           }
           return count >= 2
       }
    
    
    func toRouteData() -> RouteData {
        var points: [NMGLatLng] = []

        for step in steps {
            if let coords = step.coordinates, !coords.isEmpty {
                for c in coords {
                    points.append(NMGLatLng(lat: c.latitude, lng: c.longitude)) // ⚠️ lat/ lng 매핑 주의
                }
            } else if let c = step.coordinate {
                points.append(NMGLatLng(lat: c.latitude, lng: c.longitude))
            }
        }

        // 인접 중복 제거 (선 떨림 방지)
        var dedup: [NMGLatLng] = []
        dedup.reserveCapacity(points.count)
        for p in points {
            if let last = dedup.last {
                if abs(last.lat - p.lat) < 1e-7 && abs(last.lng - p.lng) < 1e-7 { continue }
            }
            dedup.append(p)
        }

        // UI 표시용 문자열
        let distStr = formatDistance(totalDistance)
        let timeStr = formatTime(totalTime)
        let arrivalStr = estimatedArrivalString(totalTime)

        return RouteData(
            title: "최단거리",
            time: timeStr,
            arrivalTime: arrivalStr,
            distance: distStr,
            path: dedup,
            elevatorPoints: nil,
            wheelchairPoints: nil,
            lineColor: .blue900
        )
    }

    private func formatDistance(_ m: Int) -> String {
        if m >= 1000 { return String(format: "%.1fkm", Double(m)/1000.0) }
        return "\(m)m"
    }

    private func formatTime(_ sec: Int) -> String {
        let m = sec / 60, s = sec % 60
        return s == 0 ? "\(m)분" : "\(m)분 \(s)초"
    }

    private func estimatedArrivalString(_ sec: Int) -> String {
        let date = Date().addingTimeInterval(TimeInterval(sec))
        let f = DateFormatter()
        f.locale = Locale(identifier: "ko_KR")
        f.dateFormat = "a h:mm 도착"
        return f.string(from: date)
    }
}
