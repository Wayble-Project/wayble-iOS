import Foundation


protocol APIRequest {
    associatedtype Response: Decodable
    var urlRequest: URLRequest { get }
}

extension APIRequest {
    func makeURLRequest() throws -> URLRequest {
        urlRequest
    }
}
