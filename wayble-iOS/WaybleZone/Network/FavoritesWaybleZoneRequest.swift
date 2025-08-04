import Foundation


struct FavoritesWaybleZoneRequest: APIRequest {
    typealias Response = FavoritesWaybleZoneResponse

    let district: String

    var urlRequest: URLRequest {
        var components = URLComponents(string: "http://localhost:8080/api/v1/wayble-zones/search/district/most-likes")!
        components.queryItems = [
            URLQueryItem(name: "district", value: district)
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        //request.setValue("Bearer \(AuthManager.token ?? "")", forHTTPHeaderField: "Authorization")
        request.setValue("Bearer valid_jwt_token", forHTTPHeaderField: "Authorization")
        return request
    }
}
