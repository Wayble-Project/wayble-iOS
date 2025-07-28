import Foundation

protocol APIRequest {
    associatedtype Response: Decodable
    var urlRequest: URLRequest { get }
}
