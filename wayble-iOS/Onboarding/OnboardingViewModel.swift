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
import SwiftUI


@Observable
class OnboardingViewModel {
    var userInfo = UserInfo()
    var isNicknameDuplicate: Bool? = nil /// 닉네임 중복 검사 실패 시 nil 반환 (false로만 하면 검사 실패 vs 중복 인 case가 구분이 안 됨)
    //var nicknameValidation: ValidationState = .valid

    var nicknameValidationState: ValidationState = .valid
    var birthValidationState: ValidationState = .valid

    
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

    //MARK: - 닉네임 유효성 함수
    private func isValidNickname(_ nickname: String) -> Bool {
        let trimmed = nickname.trimmingCharacters(in: .whitespacesAndNewlines)

        // 길이 검사 (8자 이하로 하는 게 낫겠지요..)
        guard (2...8).contains(trimmed.count) else { return false }

        // 허용 문자: 한글 또는 영어만 (숫자, 특수문자, 이모지 등 제외)
        let allowedPattern = "^[가-힣a-zA-Z]+$"
        guard trimmed.range(of: allowedPattern, options: .regularExpression) != nil else {
            return false
        }

        // 자음/모음만 있는 조합 거르기
        let jamoPattern = "^[ㄱ-ㅎㅏ-ㅣ]+$"
        if trimmed.range(of: jamoPattern, options: .regularExpression) != nil {
            return false
        }

        return true
    }
    
}

extension OnboardingViewModel {
    var isNicknameValid: Bool {
        userInfo.nickname.count >= 2 && isNicknameDuplicate == false
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
    
//MARK: - 닉네임 상태 case
    
    var checkNicknameState: ValidationState { ///0806
        if userInfo.nickname.isEmpty {
            return .valid
        } else if userInfo.nickname.count < 2 {
            return .tooShort(min: 2)
        } else if isNicknameDuplicate == true {
            return .duplicated
        } else if !isValidNickname(userInfo.nickname) { /// 2~8자, 특수문자, 자모음 이슈
            return .invalidNicknameFormat
        } else {
            return .valid
        }
    }

    //MARK: - 생년월일 상태 case
    
    var checkBirthState: ValidationState { ///0806
        ///계산 속성이 하는 역할 ; userInfo.birth 값이 바뀔 때마다, 항상 실시간으로 최신의 유효성 상태를 알려줌
        let pattern = #"^\d{4}-\d{2}-\d{2}$"#
        if userInfo.birth.isEmpty {
            return .valid
        } else if userInfo.birth.range(of: pattern, options: .regularExpression) == nil {
            return .invalidBirthFormat
        } else {
            return .valid
        }
    }
}

//MARK: - 닉네임 중복 로직 -> NicknameService에 함수 생성 완료

extension OnboardingViewModel {
    @MainActor
    func checkNicknameDuplicate(nickname: String) async {
        do {
            let response = try await NicknameService().checkNicknameDuplicate(nickname: nickname)
            self.isNicknameDuplicate = !response.data.available
        } catch {
            print("중복 확인 실패: \(error)")
            self.isNicknameDuplicate = nil
        }
    }
}
