import Foundation

struct AuthAPIClient {
    enum AuthClientError: Error {
        case httpError(Int, Data?)
        case decodingError(Error)
        case missingURL
    }

    public func send<T: APIRequest>(_ request: T) async throws -> T.Response {
        // 1) APIRequest -> URLRequest로 변환
        var req = try request.makeURLRequest()

        // 2) 토큰이 있으면 Authorization 주입
        if let token = KeychainManager.standard
            .loadSession(for: "tokenInfoKey")?
            .accessToken
        {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        // 3) 호출
        let (data, response) = try await URLSession.shared.data(for: req)
        
        print("Raw JSON:")
        print(String(data: data, encoding: .utf8) ?? "invalid JSON")


        // 4) 상태코드 체크
        if let http = response as? HTTPURLResponse,
           !(200...299).contains(http.statusCode) {
            throw AuthClientError.httpError(http.statusCode, data) // 기존 에러 타입 사용
        }

        // 5) 디코딩
        do {
            return try JSONDecoder().decode(T.Response.self, from: data)
        } catch {
            throw AuthClientError.decodingError(error)
        }
    }

}
