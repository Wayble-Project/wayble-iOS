import Foundation

/// GET /api/v1/wayble-zones/search/maps
/// Query:
/// - latitude (필수, -90...90)
/// - longitude (필수, -180...180)
/// - radiusKm (선택, >= 0.1km)
/// - zoneName (선택, 2글자 이상)
/// - zoneType (선택: RESTAURANT | CAFE)
/// - page (선택, 기본 0)
/// - size (선택, 기본 30)
struct WaybleZoneMapSearchRequest: APIRequest {
    typealias Response = SimpleAPIResponse<Page<WaybleZoneMapSearchItem>>

    let latitude: Double
    let longitude: Double
    let radiusKm: Double?
    let zoneName: String?
    let zoneType: ZoneType?
    let page: Int
    let size: Int

    init(
        latitude: Double,
        longitude: Double,
        radiusKm: Double? = nil,
        zoneName: String? = nil,
        zoneType: ZoneType? = nil,
        page: Int = 0,
        size: Int = 30
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.radiusKm = radiusKm
        self.zoneName = zoneName
        self.zoneType = zoneType
        self.page = page
        self.size = size
    }

    var urlRequest: URLRequest {
        var components = URLComponents(string: "https://wayble.site/api/v1/wayble-zones/search/maps")!
        var items: [URLQueryItem] = [
            .init(name: "latitude", value: String(latitude)),
            .init(name: "longitude", value: String(longitude)),
            .init(name: "page", value: String(page)),
            .init(name: "size", value: String(size))
        ]

        if let radiusKm {
            items.append(.init(name: "radiusKm", value: String(radiusKm)))
        }
        if let zoneName, !zoneName.isEmpty {
            items.append(.init(name: "zoneName", value: zoneName))
        }
        if let zoneType {
            items.append(.init(name: "zoneType", value: zoneType.rawValue))
        }

        components.queryItems = items

        var req = URLRequest(url: components.url!)
        req.httpMethod = "GET"
        return req
    }
}
