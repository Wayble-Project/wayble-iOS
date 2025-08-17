import Foundation

/// POST /api/v1/wayble-zones/{zoneID}/reviews
struct ReviewPostRequest: APIRequest {
    typealias Response = APIResponse<EmptyData>

    let zoneID: Int
    let payload: ReviewPostRequestModel

    var urlRequest: URLRequest {

        var components = URLComponents(string: "https://wayble.site/api/v1/wayble-zones/\(zoneID)/reviews")!

        var req = URLRequest(url: components.url!)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")


        let encoder = JSONEncoder()

        req.httpBody = try? encoder.encode(payload)

        return req
    }
}
