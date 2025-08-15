//
//  NetworkErrorHelper.swift
//  wayble-iOS
//
//  Created by 이서현 on 8/15/25.
//

import Foundation

func presentErrorMessage(status: Int?, message: String?) -> (title: String, body: String) {
    let userMessage: String
    switch status ?? -1 { ///-1은 실제 HTTP 상태코드에 없는 값임 ->  nil일 경우 default로 빠지게 하는 용도 0815
    case 400:
        userMessage = "요청 값이나 옵션이 잘못됐어요. 입력 값을 다시 확인해 주세요."
    case 401, 403:
        userMessage = "인증에 실패했어요. API 키와 권한을 확인해 주세요."
    case 404:
        userMessage = "해당 조건으로 데이터를 찾을 수 없어요. 다른 조건으로 시도해 보세요."
    case 500...599:
        userMessage = "서버가 잠시 불안정해요. 잠시 후 다시 시도해 주세요."
    default:
        userMessage = "알 수 없는 오류예요. 네트워크 상태를 확인해 주세요."
    }
    
    let serverMessage = (message?.isEmpty == false) ? "\n(\(message!))" : ""
    return ("경로를 찾을 수 없어요", userMessage + serverMessage)
}
