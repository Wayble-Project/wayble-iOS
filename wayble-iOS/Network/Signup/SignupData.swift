//
//  SignupData.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/20/25.
//

import Foundation

struct SignupData: Codable {
    let email: String
    let password: String
    let loginType: String
}

struct SignupPatchRequest: Codable {
    let email: String?
    let password: String?
}
