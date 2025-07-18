//
//  UserModel.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/16/25.
//

import Observation

@Observable
class UserInfo {
    var email: String = ""
    var password: String = ""
    var nickname: String = ""
    var gender: Gender = .none
    var birth: String = "" //Date 타입으로 해야 하는지
    var hasDisability: Bool = false
    var disabilityType: [DisabilityType] = []
    var mobilityAid: MobilityAid = .none
    var isWithCompanion: Bool = false
    
    enum DisabilityType: String, CaseIterable, Identifiable {
        case visual = "시각장애"
        case hearing = "청각장애"
        case physical = "지체장애"
        case cognitive = "지적장애"
        case speech = "언어장애"
        
        var id: Self { self }
    }
    
    
    enum Gender: String, CaseIterable, Identifiable {
        case male = "남자"
        case female = "여자"
        case none = "선택 안 함"
        
        var id: Self { self }
    }
    
    
    enum MobilityAid: String, CaseIterable, Identifiable {
        case none = "없음"
        case wheelchair = "휠체어"
        case crutch = "목발"
        case walker = "보행기"
        
        var id: Self { self }
    }
    
}
