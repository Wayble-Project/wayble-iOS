//
//  OnboardingResponse.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/31/25.
//

struct OnboardingResponse: Codable {
    let errorCode: Int?
    let message: String?
    let data: OnboardingData?
}



struct OnboardingPostResponse: Codable {
    let data: String
}


