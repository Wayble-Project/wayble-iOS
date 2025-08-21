import Foundation

/// GET /api/v1/users/places?sort=latest|name
struct SimpleUsersPlaceListRequest: APIRequest {
    typealias Response = SimpleAPIResponse<[SimpleSavedPlaceResponse]>

    let sort: UserPlaceSort    // 기본은 .latest (서버 기본과 동일)

    var urlRequest: URLRequest {
        var components = URLComponents(string: "https://wayble.site/api/v1/users/places")!
        // 서버 기본이 latest이므로 latest면 굳이 쿼리를 붙이지 않아도 됨
        if sort != .latest {
            components.queryItems = [URLQueryItem(name: "sort", value: sort.rawValue)]
        }
        var req = URLRequest(url: components.url!)
        req.httpMethod = "GET"
        
        return req
    }
}
