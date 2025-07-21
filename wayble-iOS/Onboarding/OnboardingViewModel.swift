//
//  OnboardingViewModel.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/21/25.
//

import Foundation

@Observable
class OnboardingViewModel {
    var userInfo = UserInfo()
    
    func completeOnboarding() async -> Bool {
        let data = OnboardingData(
            nickname: userInfo.nickname,
            birthDate: userInfo.birth,
            gender: userInfo.gender == .none ? "" : userInfo.gender.rawValue,
            userType: userInfo.hasDisability ? "DISABLED" : "NON_DISABLED",
            mobilityAid: userInfo.mobilityAid.contains(.none) && userInfo.mobilityAid.count == 1 ? nil : userInfo.mobilityAid.map { $0.rawValue }.joined(separator: ","),
            disabilityType: userInfo.disabilityType.isEmpty ? nil : userInfo.disabilityType.map { $0.rawValue }.joined(separator: ","),
            isWithCompanion: userInfo.hasDisability ? nil : userInfo.isWithCompanion
        )

        do {
            _ = try await OnboardingService().createOnboarding(data)
            return true
        } catch {
            print("온보딩 등록 실패: \(error)")
            return false
        }
    }
}

