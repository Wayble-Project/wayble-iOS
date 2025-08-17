//
//  MainMapViewModel.swift
//  wayble-iOS
//
//  Created by 이서현 on 8/12/25.
//

import Foundation
import Moya

@MainActor
final class MainMapViewModel: ObservableObject {
    @Published var homeFacilities: [HomeFacility] = [] ///HomeFacility 인스턴스를 담은 배열 저장
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = MainMapService()

    func loadFacilities(lat: Double, lng: Double, facilityType: String) async {
        isLoading = true
        errorMessage = nil
        do {
            ///service.getHomeWaybleZone ->  API 호출
            let response = try await service.getHomeWaybleZone(
                latitude: lat,
                longitude: lng,
                facilityType: facilityType
            )

            // 응답 → HomeFacility 배열로 변환
            homeFacilities = response.data.map { ///map은 배열의 각 요소를 변환하는 함수
                HomeFacility(
                    latitude: $0.latitude, ///$0 → response.data 배열의 현재 요소
                    longitude: $0.longitude,
                    facilityType: $0.facilityType
                )
            }

            isLoading = false
            //MARK: - error 처리
        } catch {
            var statusCode: Int? = nil
            var serverMessage: String? = nil

            if let moyaError = error as? MoyaError {
                if case let .statusCode(response) = moyaError {
                    statusCode = response.statusCode
                    if let decoded = try? JSONDecoder().decode(ErrorResponse.self, from: response.data) {
                        serverMessage = decoded.message
                    }
                }
            }

            let errorInfo = presentErrorMessage(status: statusCode, message: serverMessage)
            errorMessage = errorInfo.body
            homeFacilities = []
            isLoading = false
        }
    }
}


