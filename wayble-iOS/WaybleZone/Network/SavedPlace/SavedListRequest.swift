import Foundation


 struct UsersSaveListRequest: APIRequest {
     typealias Response = SimpleAPIResponse<PlaceListResponse>


     let payload: SaveList


     var urlRequest: URLRequest {
         
        var components = URLComponents(string: "https://wayble.site/api/v1/users/places")!

        var req = URLRequest(url: components.url!)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")

        req.httpBody = try? JSONEncoder().encode(payload)
        return req
    }
}
