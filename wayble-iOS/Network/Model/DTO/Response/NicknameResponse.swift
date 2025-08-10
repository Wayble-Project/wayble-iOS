//
//  NicknameResponse.swift
//  wayble-iOS
//
//  Created by 이서현 on 8/6/25.
//


struct NicknameResponse: Codable {
    let errorCode: Int?
    let message: String?
    let data: NicknameData?
}


struct NicknameData: Codable {
    let available: Bool
    let message: String
}


