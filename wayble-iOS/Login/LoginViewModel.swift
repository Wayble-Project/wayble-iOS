//
//  LoginViewModel.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/14/25.
//

import Foundation


import SwiftUI

// FIXME
@Observable
class LoginViewModel {
    var userInfo = UserInfo()
    var isCheckingMismatch: Bool = false
    
    func login() async throws -> TokenInfo {
        let token = try await LoginService().login(
            LoginData(
                email: userInfo.email,
                password: userInfo.password,
                loginType: userInfo.loginType.rawValue
            )
        )
        return TokenInfo(
            accessToken: token.accessToken,
            refreshToken: token.refreshToken
        )
    }
}
