import Foundation

struct FilesUploadJSONRequest: APIRequest {
    typealias Response = APIResponse<[String]>

    private let body: UploadImagesBody

    init(base64Images: [String]) {
        self.body = .init(images: base64Images)
    }

    var urlRequest: URLRequest {
        var req = URLRequest(url: URL(string: "https://wayble.site/api/v1/files/images")!)
        req.httpMethod = "POST"
        req.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONEncoder().encode(body)
        return req
    }
}
