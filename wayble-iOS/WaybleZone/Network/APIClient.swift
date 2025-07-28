import Foundation

struct APIClient {
    func send<T: APIRequest>(_ request: T) async throws -> T.Response {
        let (data, response) = try await URLSession.shared.data(for: request.urlRequest)
        
         //print("Raw JSON:")
         //print(String(data: data, encoding: .utf8) ?? "invalid JSON")

        if let httpResponse = response as? HTTPURLResponse,
           !(200..<300).contains(httpResponse.statusCode) {
            throw NSError(domain: "HTTP Error", code: httpResponse.statusCode)
        }

        return try JSONDecoder().decode(T.Response.self, from: data)
    }
}
