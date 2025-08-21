import Foundation

struct WaybleZoneRequest: APIRequest {
    typealias Response = WaybleZoneResponse

    let city: String
    let category: String

    var urlRequest: URLRequest {
        var components = URLComponents(string: "https://wayble.site/api/v1/wayble-zones")!
        components.queryItems = [
            URLQueryItem(name: "city", value: city),
            URLQueryItem(name: "category", value: category)
        ]

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        return request
    }
}
