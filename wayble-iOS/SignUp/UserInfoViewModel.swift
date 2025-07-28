//
//  SignupViewModel.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/14/25.
//
import Foundation
import SwiftUI
import Observation




//@Observable 과 @Appstorage를 같이 쓰면 가끔 문제가 생기나봄...? << 확인해봐야 함



/*
class SignupViewModel: ObservableObject {
    @Published var signupModel = SignupModel(email: "", password: "")

    //@AppStorage("email") var email: String = ""
    //@AppStorage("pwd") var pwd: String = ""

    func saveUserData() { //지피티의 도움..
        //email = signupModel.email
        //pwd = signupModel.password
    }
}

*/


@Observable
class UserInfoViewModel {
    var userInfo = UserInfo()

    //@AppStorage("email") var email: String = ""
    //@AppStorage("pwd") var pwd: String = ""

    func saveUserData() {
        // 예:appstorge에 저장하거나 서버에 보낼 때?
        //email = userInfo.email
        //pwd = userInfo.password
    }
}
