//
//  UserRouter.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/20/25.
//


//FIXME: -파라미터 확인하기
import Foundation
import Moya

enum UserRouter {
    case getPerson(email: String) //파라미터 확인
    case postPerson(userData: UserData)
    case patchPerson(patchData: UserPatchRequest)
    case putPerson(UserData: UserData)
    case deletePerson(email: String) //파라미터 확인
}

extension UserRouter: APITargetType {
    var path: String {
        return "/signup"
    }
    
    var method: Moya.Method {
        switch self {
        case .getPerson:
            return .get
        case .postPerson:
            return .post
        case .patchPerson:
            return .patch
        case .putPerson:
            return .put
        case .deletePerson:
            return .delete
        }
    }
    
    var task: Task {
        switch self {
        case .getPerson(let email), .deletePerson(let email):
            return .requestParameters(parameters: ["email": email], encoding: URLEncoding.queryString)
        case .postPerson(let userData), .putPerson(let userData):
            return .requestJSONEncodable(userData)
        case .patchPerson(let patchData):
            return .requestJSONEncodable(patchData)
        }
    }
}
