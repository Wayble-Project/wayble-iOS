import Foundation
//
//final class FilesService: FilesServiceProtocol {
//    private let apiClient: AuthAPIClient
//    init(apiClient: AuthAPIClient = AuthAPIClient()) { self.apiClient = apiClient}
//
//    func uploadImagesBase64(_ imagesBase64: [String]) async throws -> [String] {
//        let req = FilesUploadJSONRequest(base64Images: imagesBase64)
//        let res: APIResponse<[String]> = try await apiClient.send(req)
//        return res.data
//    }
//}



//
//struct FilesService: FilesServiceProtocol {
//    func uploadImagesMultipart(_ datas: [Data]) async throws -> [String] {
//        let req = FilesUploadMultipartRequest(imageDatas: datas).urlRequest
//        let (data, resp) = try await URLSession.shared.data(for: req)
//        guard let http = resp as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
//            let message = String(data: data, encoding: .utf8) ?? ""
//            throw NSError(domain: "Upload", code: (resp as? HTTPURLResponse)?.statusCode ?? -1,
//                          userInfo: [NSLocalizedDescriptionKey: "업로드 실패: \(message)"])
//        }
//        let decoded = try JSONDecoder().decode(APIResponse<[String]>.self, from: data)
//        return decoded.data
//    }
//}
struct FilesService: FilesServiceProtocol {
    // 네 프로젝트의 API 클라이언트 타입으로 바꿔줘
    // 예: let client: AuthAPIClient
        private let apiClient: AuthAPIClient
        init(apiClient: AuthAPIClient = AuthAPIClient()) { self.apiClient = apiClient}

    func uploadImagesMultipart(_ datas: [Data]) async throws -> [String] {
        // 디버그 로그
        print("➡️ [FILES] POST /api/v1/files/images  parts=\(datas.count)")
        datas.enumerated().forEach { i, d in
            print("   • [\(i)] \(d.count/1024) KB")
        }

        let res: SimpleAPIResponse<[String]> = try await apiClient.send(
            FilesUploadMultipartRequest(imageDatas: datas)
        )

        print("⬅️ [FILES] success urls=\(res.data.count)")
        return res.data
    }
}
