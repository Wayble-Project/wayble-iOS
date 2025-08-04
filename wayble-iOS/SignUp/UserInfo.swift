//
//  UserModel.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/16/25.
//

import Observation

@Observable
class UserInfo {
    var email: String
    var password: String
    var nickname: String
    var birth: String
    var gender: Gender
    var hasDisability: Bool
    var disabilityType: [DisabilityType]
    var mobilityAid: [MobilityAid]
    var isWithCompanion: Bool
    var loginType: LoginType 

    init(
        email: String = "",
        password: String = "",
        nickname: String = "",
        birth: String = "",
        gender: Gender = .none,
        hasDisability: Bool = false,
        disabilityType: [DisabilityType] = [],
        mobilityAid: [MobilityAid] = [],
        isWithCompanion: Bool = false,
        loginType: LoginType = .basic
    ) {
        self.email = email
        self.password = password
        self.nickname = nickname
        self.birth = birth
        self.gender = gender
        self.hasDisability = hasDisability
        self.disabilityType = disabilityType
        self.mobilityAid = mobilityAid
        self.isWithCompanion = isWithCompanion
        self.loginType = loginType
    }
}


// MARK: - 버튼 선택 시 UserType 넣기
enum UserType: String, Codable {
    case general = "GENERAL" ///일반 사용자
    case disabled = "DISABLED"
    case companion = "COMPANION"
}


enum DisabilityType: String, CaseIterable, Identifiable, Codable {
    case visual = "VISUAL" //시각장애
    case hearing = "AUDITORY" //청각장애
    case physical = "PHYSICAL" //지체장애
    case cognitive = "DEVELOPMENTAL" //발달장애

    var id: Self { self }
}

enum Gender: String, CaseIterable, Identifiable, Codable {
    case male = "MALE"
    case female = "FEMALE"
    case none = "UNKNOWN"

    var id: Self { self }
}

enum MobilityAid: String, CaseIterable, Identifiable, Codable {
    case none = "NONE" //없음
    case wheelchair = "WHEELCHAIR" //휠체어
    case walkingStick = "CANE" //지팡이
    case guideDog = "GUIDE_DOG" //안내견

    var id: Self { self }
}

enum LoginType: String, Codable {
    case basic = "BASIC"
    case kakao = "KAKAO"
    case apple = "APPLE"
}
