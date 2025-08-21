import Foundation

enum MapSearchValidationError: LocalizedError {
    case invalidLatitude, invalidLongitude
    case radiusTooSmall
    case zoneNameTooShort

    var errorDescription: String? {
        switch self {
        case .invalidLatitude:  return "위도는 -90.0 ~ 90.0 사이여야 합니다."
        case .invalidLongitude: return "경도는 -180.0 ~ 180.0 사이여야 합니다."
        case .radiusTooSmall:   return "검색 반경은 0.1km 이상이어야 합니다."
        case .zoneNameTooShort: return "zoneName은 최소 2글자 이상이어야 합니다."
        }
    }
}

final class WaybleZoneMapSearchService: WaybleZoneMapSearchServiceProtocol {
    private let apiClient: AuthAPIClient

    init(apiClient: AuthAPIClient = AuthAPIClient()) {
        self.apiClient = apiClient
    }

    func searchMaps(
        latitude: Double,
        longitude: Double,
        radiusKm: Double? = nil,
        zoneName: String? = nil,
        zoneType: ZoneType? = nil,
        page: Int = 0,
        size: Int = 30
    ) async throws -> Page<WaybleZoneMapSearchItem> {

        
        guard (-90.0...90.0).contains(latitude) else { throw MapSearchValidationError.invalidLatitude }
        guard (-180.0...180.0).contains(longitude) else { throw MapSearchValidationError.invalidLongitude }
        if let r = radiusKm, r < 0.1 { throw MapSearchValidationError.radiusTooSmall }
        if let name = zoneName, !name.isEmpty, name.count < 2 { throw MapSearchValidationError.zoneNameTooShort }

        let req = WaybleZoneMapSearchRequest(
            latitude: latitude,
            longitude: longitude,
            radiusKm: radiusKm,
            zoneName: zoneName,
            zoneType: zoneType,
            page: page,
            size: size
        )

        let res: SimpleAPIResponse<Page<WaybleZoneMapSearchItem>> = try await apiClient.send(req)
        return res.data
    }
}

