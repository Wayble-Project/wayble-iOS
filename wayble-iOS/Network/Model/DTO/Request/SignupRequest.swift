//
//  SignupRequest.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/23/25.
//

import Foundation

struct SignupData: Codable {
    let email: String
    let password: String
    var loginType: String = "BASIC"
}

struct SignupPatchRequest: Codable {
    let email: String?
    let password: String?
}
