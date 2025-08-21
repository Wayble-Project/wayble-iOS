import Foundation

/// DELETE /api/v1/users/places/zones?placeId=3&waybleZoneId=280
struct UsersPlaceDeleteRequest: APIRequest {

    typealias Response = APIResponse<EmptyData>

    let placeId: Int
    let waybleZoneId: Int

    var urlRequest: URLRequest {
        var components = URLComponents(string: "https://wayble.site/api/v1/users/places/zones")!
        components.queryItems = [
            URLQueryItem(name: "placeId", value: String(placeId)),
            URLQueryItem(name: "waybleZoneId", value: String(waybleZoneId))
        ]

        var req = URLRequest(url: components.url!)
        req.httpMethod = "DELETE"

        return req
    }
}
