import Foundation

struct AuthAPIClient {
    enum AuthClientError: Error {
        case httpError(Int, Data?)
        case decodingError(Error)
        case missingURL
    }

    public func send<T: APIRequest>(_ request: T) async throws -> T.Response {

        var req = request.urlRequest

        // accessToken
        if let token = KeychainManager.standard
            .loadSession(for: "tokenInfoKey")?
            .accessToken
        {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }

        let (data, response) = try await URLSession.shared.data(for: req)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print("응답이 HTTP가 아님:", response)
            throw URLError(.badServerResponse)
        }

        print("status =", httpResponse.statusCode)
        
     
        print("Raw JSON:")
        print(String(data: data, encoding: .utf8) ?? "invalid JSON")


//        if let http = response as? HTTPURLResponse,
//           !(200...299).contains(http.statusCode) {
//            throw AuthClientError.httpError(http.statusCode, data)
//        }
        
        
        
        if let httpResponse = response as? HTTPURLResponse,
           !(200..<300).contains(httpResponse.statusCode) {
            throw NSError(domain: "HTTP Error", code: httpResponse.statusCode)
        }
        
      
            return try JSONDecoder().decode(T.Response.self, from: data)
         

//        do {
//            return try JSONDecoder().decode(T.Response.self, from: data)
//        } catch {
//            throw AuthClientError.decodingError(error)
//        }
    }

}







//import Foundation
//
//
//extension APIResponse where T == EmptyData {
//    /// 서버가 바디 없이 2xx를 주는 경우에 사용할 "성공 응답" 팩토리
//    static func emptySuccess(message: String = "OK") -> APIResponse<EmptyData> {
//        APIResponse<EmptyData>(errorCode: 0, message: message, data: EmptyData())
//    }
//}
//struct AuthAPIClient {
//    enum AuthClientError: Error {
//        case httpError(Int, Data?)
//        case decodingError(Error)
//        case missingURL
//        case emptyBodyNotDecodable
//    }
//
//    public func send<T: APIRequest>(_ request: T) async throws -> T.Response {
//        var req = request.urlRequest
//
//        // Bearer
//        if let token = KeychainManager.standard
//            .loadSession(for: "tokenInfoKey")?
//            .accessToken {
//            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//        }
//
//        // ▶︎ 요청 로그
//        print("➡️ [HTTP] \(req.httpMethod ?? "GET") \(req.url?.absoluteString ?? "")")
//        if let ct = req.value(forHTTPHeaderField: "Content-Type") { print("   Content-Type:", ct) }
//        if let acc = req.value(forHTTPHeaderField: "Accept") { print("   Accept:", acc) }
//        if let body = req.httpBody, !body.isEmpty, let s = String(data: body, encoding: .utf8) {
//            print("   body:", s)
//        } else {
//            print("   body: <empty>")
//        }
//
//        let (data, response) = try await URLSession.shared.data(for: req)
//        guard let http = response as? HTTPURLResponse else { throw URLError(.badServerResponse) }
//
//        // ◀︎ 응답 로그
//        print("⬅️ [HTTP] status =", http.statusCode)
//        let raw = String(data: data, encoding: .utf8) ?? ""
//        print("   resp:", raw.isEmpty ? "<empty>" : raw)
//
//        guard (200..<300).contains(http.statusCode) else {
//            throw AuthClientError.httpError(http.statusCode, data)
//        }
//
//        // --- 공통: '빈' 바디 처리 ---
//        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
//        let isEmptyLike = trimmed.isEmpty || trimmed == "null" || trimmed == "{}"
//        if isEmptyLike {
//            if T.Response.self == APIResponse<EmptyData>.self {
//                let fake = APIResponse<EmptyData>.emptySuccess()
//                return (fake as! T.Response)
//            }
//            if T.Response.self == EmptyData.self {
//                return (EmptyData() as! T.Response)
//            }
//            throw AuthClientError.emptyBodyNotDecodable
//        }
//
//        // --- 🔧 추가: APIResponse<EmptyData> 전용 'data:null / data 누락' 느슨한 처리 ---
//        if T.Response.self == APIResponse<EmptyData>.self {
//            // 1) 먼저 정상 디코딩을 시도
//            if let ok = try? JSONDecoder().decode(APIResponse<EmptyData>.self, from: data) {
//                return (ok as! T.Response)
//            }
//            // 2) data가 null이거나 누락된 경우를 위해 느슨하게 파싱
//            struct LooseNoData: Decodable {
//                let errorCode: Int
//                let message: String
//                // data가 null/누락이어도 통과시키기 위해 Optional로 두지 않고 아예 생략
//                // (decoder가 모르는 키는 무시됨)
//            }
//            if let loose = try? JSONDecoder().decode(LooseNoData.self, from: data) {
//                let fake = APIResponse<EmptyData>(errorCode: loose.errorCode,
//                                                  message: loose.message,
//                                                  data: EmptyData())
//                return (fake as! T.Response)
//            }
//            // 3) 그래도 안되면 원래 에러로
//            throw AuthClientError.decodingError(
//                DecodingError.dataCorrupted(.init(codingPath: [],
//                    debugDescription: "Unable to decode APIResponse<EmptyData> (data null/missing?)"))
//            )
//        }
//
//        // --- 일반 경로 ---
//        do {
//            return try JSONDecoder().decode(T.Response.self, from: data)
//        } catch {
//            throw AuthClientError.decodingError(error)
//        }
//    }
//
//}
