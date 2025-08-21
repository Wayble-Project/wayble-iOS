import Foundation

/// GET /api/v1/users/places/zones?placeId=3&page=1&size=20
struct UsersPlaceZonesListRequest: APIRequest {
  
    typealias Response = SimpleAPIResponse<Page<WaybleZone>>

    let placeId: Int
    let page: Int
    let size: Int

    init(placeId: Int, page: Int = 1, size: Int = 20) {
        self.placeId = placeId
        self.page = page
        self.size = size
    }

    var urlRequest: URLRequest {
        var components = URLComponents(string: "https://wayble.site/api/v1/users/places/zones")!
        components.queryItems = [
            URLQueryItem(name: "placeId", value: String(placeId)),
            URLQueryItem(name: "page", value: String(page)), // 0을 줘야하는지?
            URLQueryItem(name: "size", value: String(size))
        ]

        var req = URLRequest(url: components.url!)
        req.httpMethod = "GET"

        return req
    }
}
