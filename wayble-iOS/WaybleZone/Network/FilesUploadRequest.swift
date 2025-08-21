//import Foundation
//
//struct FilesUploadJSONRequest: APIRequest {
//    typealias Response = APIResponse<[String]>
//
//    private let body: UploadImagesBody
//
//    init(base64Images: [String]) {
//        self.body = .init(images: base64Images)
//    }
//
//    var urlRequest: URLRequest {
//        var req = URLRequest(url: URL(string: "https://wayble.site/api/v1/files/images")!)
//        req.httpMethod = "POST"
//        req.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
//        req.httpBody = try? JSONEncoder().encode(body)
//        return req
//    }
//}
//import Foundation
//
//struct FilesUploadMultipartRequest: APIRequest {
//    typealias Response = APIResponse<[String]>
//
//    private let imageDatas: [Data]
//
//    init(imageDatas: [Data]) {
//        self.imageDatas = imageDatas
//    }
//
//    var urlRequest: URLRequest {
//        var req = URLRequest(url: URL(string: "https://wayble.site/api/v1/files/images")!)
//        req.httpMethod = "POST"
//
//        let boundary = "----Wayble-\(UUID().uuidString)"
//        req.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        var body = Data()
//        for (i, data) in imageDatas.enumerated() where !data.isEmpty {
//            body.appendMultipartFile(
//                name: "images",                     // 🔴 스펙상 키: images
//                filename: "image_\(i).jpg",         // 파일명은 아무거나 가능
//                mimeType: "image/jpeg",
//                data: data,
//                boundary: boundary
//            )
//        }
//        body.appendString("--\(boundary)--\r\n")
//        req.httpBody = body
//        return req
//    }
//}
//
//// MARK: - Helpers
//private extension Data {
//    mutating func appendString(_ s: String) {
//        if let d = s.data(using: .utf8) { append(d) }
//    }
//    mutating func appendMultipartFile(
//        name: String,
//        filename: String,
//        mimeType: String,
//        data: Data,
//        boundary: String
//    ) {
//        appendString("--\(boundary)\r\n")
//        appendString("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n")
//        appendString("Content-Type: \(mimeType)\r\n\r\n")
//        append(data)
//        appendString("\r\n")
//    }
//}
import Foundation

/// 서버 스펙: POST https://wayble.site/api/v1/files/images
/// Content-Type: multipart/form-data; boundary=...
/// 파트 키: images (여러 장이면 같은 키 반복)
struct FilesUploadMultipartRequest: APIRequest {
    typealias Response = SimpleAPIResponse<[String]> // {"data":[url,...]}

    private let imageDatas: [Data]
    private let boundary: String = "----Wayble-\(UUID().uuidString)"

    init(imageDatas: [Data]) {
        self.imageDatas = imageDatas
    }

    var urlRequest: URLRequest {
        var req = URLRequest(url: URL(string: "https://wayble.site/api/v1/files/images")!)
        req.httpMethod = "POST"

        // 만약 Auth 미들웨어가 자동 주입하지 않는다면, 아래 주석 해제
        // req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        req.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        // multipart body
        var body = Data()
        for (i, data) in imageDatas.enumerated() where !data.isEmpty {
            body.appendMultipartFile(
                name: "images",                    // ✅ 서버 스펙상의 키
                filename: "image_\(i).jpg",
                mimeType: "image/jpeg",
                data: data,
                boundary: boundary
            )
        }
        body.appendString("--\(boundary)--\r\n")
        req.httpBody = body
        return req
    }
}

// MARK: - Data helpers (multipart 작성)
private extension Data {
    mutating func appendString(_ s: String) {
        if let d = s.data(using: .utf8) { append(d) }
    }

    mutating func appendMultipartFile(
        name: String,
        filename: String,
        mimeType: String,
        data: Data,
        boundary: String
    ) {
        appendString("--\(boundary)\r\n")
        appendString("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n")
        appendString("Content-Type: \(mimeType)\r\n\r\n")
        append(data)
        appendString("\r\n")
    }
}
