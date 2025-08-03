//
//  WalkModel.swift
//  wayble-iOS
//
//  Created by 신민정 on 8/2/25.
//

import SwiftUI
import Foundation
import NMapsMap

struct RouteData: Identifiable {
    let id = UUID() // List에서 ForEach 쓸 경우를 대비
    let title: String
    let time: String
    let arrivalTime: String
    let distance: String
    let path: [NMGLatLng]
    let elevatorPoints: [NMGLatLng]?
    let wheelchairPoints: [NMGLatLng]?
    let lineColor: UIColor
}

