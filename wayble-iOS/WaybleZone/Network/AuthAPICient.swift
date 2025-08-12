//import Foundation
//
// struct AuthAPIClient {
//     enum AuthClientError: Error {
//         case httpError(Int, Data?)
//         case decodingError(Error)
//         case missingURL
//     }
//
//
//    public func send<T: APIRequest>(_ request: T) async throws -> T.Response {
//
//        if let token = KeychainService.shared.currentToken()?.accessToken {
//                  req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//              }
//        
//        let (data, response) = try await URLSession.shared.data(for: request.urlRequest)
//        
//        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
//                    throw AuthClientError.httpError(http.statusCode, data)
//                }
//        
//        do {
//                    return try JSONDecoder().decode(T.Response.self, from: data)
//                } catch {
//                    throw AuthClientError.decodingError(error)
//                }
//    }
//}
//
