//
//  SignupRequest.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/23/25.
//

import Foundation

struct SignupRequest: Encodable {
    let email: String
    let password: String
    let loginType: String
}
