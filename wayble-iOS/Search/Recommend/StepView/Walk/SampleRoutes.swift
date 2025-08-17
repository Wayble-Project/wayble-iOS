//
//  SampleRoutes.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/29/25.
//

import NMapsMap
import Swift

struct SampleRoutes {
    static let wayble = RouteData(
        title: "웨이블 추천거리",
        time: "12분",
        arrivalTime: "오후 3:40 도착",
        distance: "500m",
        path: [
            NMGLatLng(lat: 37.536577, lng: 126.964031),
            NMGLatLng(lat: 37.536881, lng: 126.963923),
            NMGLatLng(lat: 37.536800, lng: 126.963782),
            NMGLatLng(lat: 37.536890, lng: 126.963694),
            NMGLatLng(lat: 37.537018, lng: 126.963629)
        ],
        elevatorPoints: [
            NMGLatLng(lat: 37.537018, lng: 126.963629)
        ],
        wheelchairPoints: [
            NMGLatLng(lat: 37.536890, lng: 126.963700)
        ],
        lineColor: .blue700
    )

    static let shortest = RouteData(
        title: "최단거리",
        time: "7분",
        arrivalTime: "오후 3:35 도착",
        distance: "413m",
        path: [NMGLatLng(lat: 37.536577, lng: 126.964031),
               NMGLatLng(lat: 37.5367520997568, lng: 126.96376041733),
               NMGLatLng(lat: 37.537018, lng: 126.963629)],
        elevatorPoints: nil,
        wheelchairPoints: nil,
        lineColor: .blue900
    )
}
