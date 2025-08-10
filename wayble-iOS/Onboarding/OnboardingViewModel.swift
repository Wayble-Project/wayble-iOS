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

    //MARK: - 생년월일 형식
    
    var checkBirthState: ValidationState { ///0806
        if userInfo.birth.isEmpty {
            return .valid
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)

        if formatter.date(from: userInfo.birth) != nil {
            return .valid
        } else {
            return .invalidBirthFormat
        }
    }
}

//MARK: - 닉네임 중복 로직 -> NicknameService에 함수 생성 완료

extension OnboardingViewModel {
    @MainActor
    func checkNicknameDuplicate(nickname: String) async {
        do {
            let response = try await NicknameService().checkNicknameDuplicate(nickname: nickname)

            if let errorCode = response.errorCode {
                print("🚫 닉네임 중복: \(response.message ?? "") (code: \(errorCode))")
                self.isNicknameDuplicate = true
                self.nicknameValidationState = .duplicated
                return
            }

            if let isAvailable = response.data?.available {
                self.isNicknameDuplicate = !isAvailable
                self.nicknameValidationState = isAvailable ? .valid : .duplicated
            } else {
                print("⚠️ 닉네임 사용 가능 여부 파악 실패")
                self.isNicknameDuplicate = nil
                self.nicknameValidationState = .invalidNicknameFormat
                //FIXME: - nicknameValidationState 를 어떻게 할까
            }
        } catch {
            print("중복 확인 실패: \(error)")
            self.isNicknameDuplicate = nil
            self.nicknameValidationState = .invalidNicknameFormat
        }
    }
}

extension OnboardingViewModel {
    func handleGender(genderString: String?) {
        guard let selected = genderString else {
            print("❌ gender 선택 실패: nil")
            return
        }
        
        let genderMap: [String: Gender] = [
            "남성": .male,
            "여성": .female,
            "선택 안 함": .none
        ]
        
        //TODO: - 리턴값 어떻게 할지
        guard let gender = genderMap[selected] else {
            print("❌ gender 매핑 실패: \(selected)")
            return
        }
        
        userInfo.gender = gender
        userInfo.birth = userInfo.birth.trimmingCharacters(in: .whitespacesAndNewlines)
        print("🎯 gender 설정됨: \(gender)")
    }
}
