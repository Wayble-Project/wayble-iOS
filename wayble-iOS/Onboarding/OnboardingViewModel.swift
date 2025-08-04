//
//  OnboardingViewModel.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/21/25.
//

//FIXME: -
 ///•    닉네임 입력하면 onChange로 API 호출
 ///•    결과는 viewModel.isNicknameDuplicate에 저장
 ///•    그 값은 isNicknameValid 및 CustomTextField.validationState에서 자동 반영


import Foundation

@Observable
class OnboardingViewModel {
    var userInfo = UserInfo()
    var isNicknameDuplicate: Bool = false

    
    func completeOnboarding() async -> Bool {
        let onboardingData = OnboardingData(
            nickname: userInfo.nickname,
            birthDate: userInfo.birth,
            gender: userInfo.gender,
            userType: userInfo.hasDisability ? .disabled : (userInfo.isWithCompanion ? .companion : .general), ///userInfo.hasDisability가 true면 "DISABLED"
            disabilityType: userInfo.hasDisability ? (userInfo.disabilityType.isEmpty ? nil : userInfo.disabilityType) : nil, ///hasDisability == true일 때만 배열 전달 (비장애인이면 nil 전달)
            mobilityAid: userInfo.hasDisability ? (userInfo.mobilityAid == [.none] ? nil : userInfo.mobilityAid) : nil
        ) ///.none(이동수단 없는 경우) 하나만 있는 경우는 nil, 그 외에는 배열 전달

        
              
              
        do {
            _ = try await OnboardingService().createOnboarding(onboardingData)
            return true
        } catch {
            print("온보딩 등록 실패: \(error)")
            return false
        }
    }
}

extension OnboardingViewModel {
    var isNicknameValid: Bool {
        userInfo.nickname.count >= 2 && !isNicknameDuplicate
    }

    var isBirthValid: Bool {
        let pattern = #"^\d{4}-\d{2}-\d{2}$"#
        return userInfo.birth.range(of: pattern, options: .regularExpression) != nil
    }

    var isDisabilityStepValid: Bool {
        if userInfo.hasDisability {
            return !userInfo.disabilityType.isEmpty || userInfo.mobilityAid != [.none]
        } else {
            return true
        }
    }
}

//TODO: - 닉네임 중복 로직 -> OnboardingService에 함수 만들기
/*
 func checkNicknameDuplicate() async {
     guard userInfo.nickname.count >= 2 else {
         isNicknameDuplicate = false
         return
     }
     
     do {
         let isDuplicate = try await OnboardingService().checkNicknameDuplication(nickname: userInfo.nickname)
         DispatchQueue.main.async {
             self.isNicknameDuplicate = isDuplicate
         }
     } catch {
         print("중복 확인 실패: \(error)")
         isNicknameDuplicate = false
     }
 }
 */
