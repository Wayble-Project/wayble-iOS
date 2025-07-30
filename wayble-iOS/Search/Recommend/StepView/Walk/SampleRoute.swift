//
//  SampleRoute.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/29/25.
//

import SwiftUI
import NMapsMap

struct SampleRoute{
    static let path: [NMGLatLng] = [
        NMGLatLng(lat: 37.536577523624985, lng: 126.96403125739117), // 출발
        NMGLatLng(lat: 37.53688157844875, lng: 126.96392362332519),
        NMGLatLng(lat: 37.5368004451298, lng: 126.96378223095306),
        NMGLatLng(lat: 37.53689051823541, lng: 126.9636944997807),
        NMGLatLng(lat:  37.53701889075801, lng: 126.96362937888357), // 도착
    
    ]

    //여러개면 여러개 받아오면 그만임. !!
    static let wheelchairPoints: [NMGLatLng] = [
        NMGLatLng(lat: 37.5368905199745, lng: 126.96370015704497)
    ]

    static let elevatorPoints: [NMGLatLng] = [
        NMGLatLng(lat:  37.53701889075801, lng: 126.96362937888357)
    ]
}
