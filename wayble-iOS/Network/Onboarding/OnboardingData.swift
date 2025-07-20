//
//  OnboardingData.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/20/25.
//

import Foundation

struct OnboardingData: Codable {
    let nickname: String
    let birthDate: String
    let gender: String
    let userType: String
    let mobilityAid: String?         // 장애인일 경우만
    let disabilityType: String?      // 장애인일 경우만
    let isWithCompanion: Bool?       // 비장애인일 경우만
}

struct OnboardingRequest: Codable {
    let nickname: String?
    let birthDate: String?
    let gender: String?
    let userType: String?
    let mobilityAid: String?         // 장애인일 경우만
    let disabilityType: String?      // 장애인일 경우만
    let isWithCompanion: Bool?       // 비장애인일 경우만
}
