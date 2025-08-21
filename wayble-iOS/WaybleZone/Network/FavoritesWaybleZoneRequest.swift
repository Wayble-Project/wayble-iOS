import Foundation


struct FavoritesWaybleZoneRequest: APIRequest {
    typealias Response = FavoritesWaybleZoneResponse

    let district: String

    var urlRequest: URLRequest {
        var components = URLComponents(string: "https://wayble.site/api/v1/wayble-zones/search/district/most-likes")!
        components.queryItems = [
            URLQueryItem(name: "district", value: district)
        ]
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"

        return request
    }
}
