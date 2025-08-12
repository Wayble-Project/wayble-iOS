import Foundation


public struct ReviewPostMetadata: Encodable {
    public let userId: Int
    public let content: String
    public let rating: Int
    public let visitDate: String
    public let facilities: [String]
}

public struct ImagePart: Sendable {
    public let data: Data
    public let filename: String
    public let mimeType: String
}


fileprivate struct Multipart {
    let boundary = "Boundary-\(UUID().uuidString)"
    private var body = Data()

    mutating func addJSON(name: String, _ encodable: some Encodable) throws {
        let json = try JSONEncoder().encode(encodable)
        addHeader(name: name, filename: nil,
                  contentType: "application/json; charset=utf-8")
        body.append(json)
        body.append("\r\n")
    }

    mutating func addData(name: String, filename: String, mimeType: String, data: Data) {
        addHeader(name: name, filename: filename, contentType: mimeType)
        body.append(data)
        body.append("\r\n")
    }

    private mutating func addHeader(name: String, filename: String?, contentType: String) {
        body.append("--\(boundary)\r\n")
        if let filename {
            body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(filename)\"\r\n")
        } else {
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n")
        }
        body.append("Content-Type: \(contentType)\r\n\r\n")
    }

    mutating func build() -> (data: Data, contentType: String) {
        body.append("--\(boundary)--\r\n")
        return (body, "multipart/form-data; boundary=\(boundary)")
    }
}

fileprivate extension Data {
    mutating func append(_ s: String) { self.append(s.data(using: .utf8)!) }
}

public struct ReviewPostRequest: APIRequest {
    public typealias Response = EmptyResponse

    private let baseURL: URL
    private let waybleZoneId: Int
    private let metadata: ReviewPostMetadata
    private let images: [ImagePart]

    public init(
        baseURL: URL,
        waybleZoneId: Int,
        metadata: ReviewPostMetadata,
        images: [ImagePart]

    ) {
        self.baseURL = baseURL
        self.waybleZoneId = waybleZoneId
        self.metadata = metadata
        self.images = images
    }

    // 프로토콜 urlRequest를 구현
    public var urlRequest: URLRequest {
        var mp = Multipart()
        do {
            try mp.addJSON(name: "metadata", metadata)
            for img in images {
                mp.addData(
                    name: "images[]",         // "images", "images[]"
                    filename: img.filename,
                    mimeType: img.mimeType,
                    data: img.data
                )
            }
        } catch {
            assertionFailure("Multipart JSON encode failed: \(error)")
        }
        let (data, contentType) = mp.build()

        var req = URLRequest(url: baseURL.appendingPathComponent("/api/v1/wayble-zones/\(waybleZoneId)/reviews"))
        req.httpMethod = "POST"
        req.httpBody = data
        req.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        return req
    }
}

// 빈 응답용
public struct EmptyResponse: Decodable { public init() {} }
