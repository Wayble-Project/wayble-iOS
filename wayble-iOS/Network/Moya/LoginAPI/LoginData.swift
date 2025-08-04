//
//  LoginData.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/30/25.
//

import Foundation

struct LoginData: Codable {
    let email: String
    let password: String
    var loginType: String = "BASIC"
}


//이거 필요없지 않나
struct LoginPatchRequest: Codable {
    let email: String?
    let password: String?
}
