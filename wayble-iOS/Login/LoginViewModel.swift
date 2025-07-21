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
    var userInfo = UserInfo()
    
    func login() {
        print("로그인 시도: \(userInfo.email), \(userInfo.password)")
    }
}
