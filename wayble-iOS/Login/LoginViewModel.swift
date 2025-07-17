//
//  LoginViewModel.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/14/25.
//

import Foundation


import SwiftUI
//import KakaoSDKUser
//import KakaoSDKAuth

@Observable
class LoginViewModel {
    var email = ""
    var pwd = ""
    
    func login() {
        print("로그인 시도: \(email), \(pwd)")
    }
}
