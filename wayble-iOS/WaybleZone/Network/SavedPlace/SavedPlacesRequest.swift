import Foundation

struct SavePlacesRequest: APIRequest {
    typealias Response = SimpleAPIResponse<String>

    let payload: SavePlacesPayload

    var urlRequest: URLRequest {
 
        let url = URL(string: "https://wayble.site/api/v1/users/places/zones")!

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONEncoder().encode(payload)
        return req
    }
}
