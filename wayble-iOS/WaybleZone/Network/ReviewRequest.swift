import Foundation

enum ReviewSort: String {
    case latest
    case rating
}

struct ReviewRequest: APIRequest {
    typealias Response = ReviewListResponse

    let zoneID: Int
    let sort: ReviewSort

    var urlRequest: URLRequest {
        var components = URLComponents(string: "http://localhost:8080/api/v1/wayble-zones/\(zoneID)/reviews")!
        components.queryItems = [
            URLQueryItem(name: "sort", value: sort.rawValue)
        ]

        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.setValue("Bearer valid_jwt_token", forHTTPHeaderField: "Authorization")
        return request
    }
}
