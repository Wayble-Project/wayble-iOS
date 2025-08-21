import Foundation

/// POST /api/v1/wayble-zones/{zoneID}/reviews
struct ReviewPostRequest: APIRequest {
    typealias Response = SimpleAPIResponse<String>

    let zoneID: Int
    let payload: ReviewPostRequestModel

    var urlRequest: URLRequest {

        var components = URLComponents(string: "https://wayble.site/api/v1/wayble-zones/\(zoneID)/reviews")!

        var req = URLRequest(url: components.url!)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.setValue("application/json", forHTTPHeaderField: "Accept")

        //req.httpBody = try? JSONEncoder().encode(payload)
        
        let body = try? JSONEncoder().encode(payload)
               req.httpBody = body

               #if DEBUG
               if let body, let s = String(data: body, encoding: .utf8) {
                   print("📤 [REVIEW] body(json):", s)
               }
               #endif

        return req
    }
}
