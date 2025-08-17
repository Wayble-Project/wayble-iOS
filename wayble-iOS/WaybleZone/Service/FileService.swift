import Foundation

struct FilesService: FilesServiceProtocol {
    private let client: AuthAPIClient
    init(client: AuthAPIClient = AuthAPIClient()) { self.client = client }

    func uploadImagesBase64(_ imagesBase64: [String]) async throws -> [String] {
        let req = FilesUploadJSONRequest(base64Images: imagesBase64)
        let res: APIResponse<[String]> = try await client.send(req)
        return res.data
    }
}
