//
//  SignupViewModel.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/21/25.
//

//FIXME: - 이메일 중복 체크 로직..
import Foundation
import SwiftUI

@Observable
class SignupViewModel {
    private let signupService: SignupService

    var userInfo = UserInfo()
    var isEmailValid: Bool = false
    var isDuplicate: Bool? = nil
    var isChecking: Bool = false
    
    init(signupService: SignupService = SignupService()) {
        self.signupService = signupService
    }

    // 이메일 형식 유효성 검사
    func validateEmailFormat() {
        isEmailValid = userInfo.email.contains("@") && userInfo.email.contains(".")
    }

    // 이메일 중복 확인
    /*
    func checkEmailDuplication() {
        guard isEmailValid else {
            isDuplicate = nil
            return
        }

        isChecking = true
        signupService.getSignup(email: userInfo.email) { result in
            DispatchQueue.main.async {
                self.isChecking = false
                switch result {
                case .success(_):
                    self.isDuplicate = true // 이미 존재하는 이메일
                case .failure(_):
                    self.isDuplicate = false // 사용 가능한 이메일
                }
            }
        }
    }
     */
    
    func signup(completion: @escaping (Bool) -> Void) {
            let signupData = SignupData(
                email: userInfo.email,
                password: userInfo.password,
                loginType: "BASIC"
            )

            print("🧾 signupData.email: \(signupData.email)")
            print("🧾 signupData.password: \(signupData.password)")

            Task {
                do {
                    let result = try await signupService.createSignup(signupData)
                    print("회원가입 성공: \(result)")
                    completion(true)
                } catch {
                    print("회원가입 실패: \(error)")
                    completion(false)
                }
            }
        }
}
