//
//  ContentsViewModel.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/20/25.
//


//TODO: - logger?
//TODO: - 응답 이후 이어지는 로직이 많아진다” 싶으면 async/await 도입하기 (week7)

/*
import Foundation
import Moya

@Observable
class ContentsViewModel {
    var userData: UserData?
    let provider: MoyaProvider<UserRouter>
    
    init() {
        let logger = NetworkLoggerPlugin(configuration: .init(logOptions: [.verbose]))
        self.provider = MoyaProvider<UserRouter>(plugins: [logger])
    }
    
    
    func getUserData(email: String) {
        provider.request(.getPerson(email: email), completion: {[weak self] result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(UserData.self, from: response.data)
                    self?.userData = decodedData
                } catch {
                    print("유저 데이터 디코더 오류", error)
                }
            case .failure(let error):
                print("error", error)
            }
            
        })
    }
    
    
    func createUser(_ userData: UserData) {
        provider.request(.postPerson(userData: userData)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(UserData.self, from: response.data)
                    print("POST 성공: \(decodedData)")
                } catch {
                    print("POST 디코더 오류", error)
                }
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
    
    func updateUserPatch(_ patchData: UserPatchRequest) {
        provider.request(.patchPerson(patchData: patchData)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(UserData.self, from: response.data)
                    print("PATCH 성공: \(decodedData)")
                } catch {
                    print("PATCH 디코더 오류", error)
                }
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
    
    func updateUserPut(_ userData: UserData) {
        provider.request(.putPerson(UserData: userData)) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try JSONDecoder().decode(UserData.self, from: response.data)
                    print("PUT 성공: \(decodedData)")
                } catch {
                    print("PUT 디코더 오류", error)
                }
            case .failure(let error):
                print("error", error)
            }
        }
    }
    
    
    func deleteUser(email: String) {
        provider.request(.deletePerson(email: email)) { result in
            switch result {
            case .success(let response):
                do {
                    let message = try JSONDecoder().decode([String: String].self, from: response.data)
                    print("DELETE 성공: \(message)")
                } catch {
                    print("DELETE 디코더 오류", error)
                }
            case .failure(let error):
                print("error", error)
            }
        }
    }
}

*/
