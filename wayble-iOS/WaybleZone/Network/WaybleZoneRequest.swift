import Foundation

struct WaybleZoneRequest: APIRequest {
    typealias Response = WaybleZoneResponse

    let city: String
    let category: String

    var urlRequest: URLRequest {
        var components = URLComponents(string: "http://localhost:8080/wayble-zone")!
        components.queryItems = [
            URLQueryItem(name: "city", value: city),
            URLQueryItem(name: "category", value: category)
        ]

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.setValue("Bearer valid_jwt_token", forHTTPHeaderField: "Authorization")
        return request
    }
}
