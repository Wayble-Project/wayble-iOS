//
//  TokenProviding.swift
//  wayble-iOS
//
//  Created by 이서현 on 7/30/25.
//

import Foundation

protocol TokenProviding {
    var accessToken: String? { get set }
    func refreshToken(completion: @escaping (String?, Error?) -> Void)
}
