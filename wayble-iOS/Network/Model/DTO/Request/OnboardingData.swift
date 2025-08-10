//
//  OnboardingData.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/20/25.
//

import Foundation

struct OnboardingData: Codable {
    let nickname: String?
    let birthDate: String?
    let gender: Gender? // 성별 (MALE, FEMALE, UNKNOWN)
    let userType: UserType? // 장애 유형 구분 (GENERAL, DISABLED, COMPANION)
    let disabilityType: [DisabilityType]?      // 장애인일 경우만 (비장애면 null)
    let mobilityAid: [MobilityAid]?        // 장애인일 경우만 (없으면 null)
}

struct OnboardingRequest: Codable {
    let nickname: String?
    let birthDate: String?
    let gender: Gender
    let userType: UserType?
    let disabilityType: [DisabilityType]?      // 장애인일 경우만
    let mobilityAid: [MobilityAid]?           // 장애인일 경우만
}

