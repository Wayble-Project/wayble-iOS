//
//  SignupModel.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/14/25.
//


import Foundation

@Observable
class SignupModel {
    var email: String
    var password: String

    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
    
    
}

