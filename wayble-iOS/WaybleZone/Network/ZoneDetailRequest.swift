import Foundation


struct ZoneDetailRequest: APIRequest {
    typealias Response = WaybleZoneResponse

    let waybleZoneId: Int

    var urlRequest: URLRequest {
        var request = URLRequest(
            url: URL(string: "https://wayble.site/api/v1/wayble-zones/\(waybleZoneId)")!
        )
        request.httpMethod = "GET"

        return request
    }
}
