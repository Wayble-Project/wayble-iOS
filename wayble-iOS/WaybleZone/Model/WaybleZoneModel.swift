import Foundation
import Observation

// MARK: - 공통 응답 포맷

struct APIResponse<T: Decodable>: Decodable {
    let errorCode: Int
    let message: String
    let data: T
}

struct SimpleAPIResponse<T: Decodable>: Decodable {
    let data: T
}

struct EmptyData: Decodable {}

// MARK: - 상세 페이지 엔티티

struct PlaceIdent: Hashable {
    let id: Int
    let name: String
}

struct WaybleZoneResponse: Codable {
    let data: WaybleZone
}

struct WaybleZone: Codable, Identifiable {
    let id: Int
    let name: String
    let category: String
    let address: String
    let rating: Double?
    let reviewCount: Int?
    let contactNumber: String?
    let imageUrl: String?
    let facilities: Facilities?
    let businessHours: [String: OpeningHours]?
    let photos: [String]?
    let latitude: Double?
    let longitude: Double?

    enum CodingKeys: String, CodingKey {
        case id = "waybleZoneId"
        case name
        case category
        case address
        case rating
        case reviewCount
        case contactNumber
        case imageUrl
        case facilities
        case businessHours
        case photos
        case latitude
        case longitude
    }
}

// 뷰단에서 ! 없이 안전하게 쓰도록 제공
extension WaybleZone {
    var safeFacilities: Facilities { facilities ?? .empty }
    var hasFacilityData: Bool { facilities != nil }
}

// MARK: - 목록(리스트)용 엔티티

struct WaybleZoneListResponse: Codable {
    let errorCode: Int
    let message: String
    let data: [Wayble]
}

struct Wayble: Codable, Identifiable {
    let id: Int
    let name: String
    let category: String
    let address: String
    let rating: Double
    let reviewCount: Int
    let imageUrl: String
    let contactNumber: String
    let facilities: Facilities

    private enum CodingKeys: String, CodingKey {
        case id = "waybleZoneId"
        case name, category, address, rating, reviewCount, imageUrl, contactNumber, facilities
    }
}

// MARK: - 시설 정보

struct Facilities: Codable {
    let hasSlope: Bool
    let hasNoDoorStep: Bool
    let hasElevator: Bool
    let hasTableSeat: Bool
    let hasDisabledToilet: Bool
    let floorInfo: String

    enum CodingKeys: String, CodingKey {
        case hasSlope
        case hasNoDoorStep
        case hasElevator
        case hasTableSeat
        case hasDisabledToilet
        case floorInfo
    }
}

extension Facilities {
    static let empty = Facilities(
        hasSlope: false,
        hasNoDoorStep: false,
        hasElevator: false,
        hasTableSeat: false,
        hasDisabledToilet: false,
        floorInfo: "1층"
    )
}

// (선택) 카테고리 enum이 필요하면 유지
enum PlaceCategory: String, Hashable, Codable, CaseIterable {
    case cafe = "CAFE"
    case restaurant = "RESTAURANT"
}

// MARK: - 영업시간

struct OpeningHours: Codable {
    let open: String
    let close: String
}

// MARK: - 저장 장소 (Saved Places)

struct SavedPlace: Identifiable, Codable {
    let placeID: Int
    let title: String
    let color: String
    let waybleZone: [WaybleZone]

    var id: Int { placeID }

    enum CodingKeys: String, CodingKey {
        case placeID = "placeId"
        case title
        case color
        case waybleZone
    }
}

struct PlaceAPIResponse: Decodable {
    let errorCode: Int
    let message: String
    let data: [Wayble]
}

struct UserPlace: Codable, Identifiable, Hashable {
    let id: Int?
    let waybleZoneId: Int
    let title: String
    let createdAt: String?
    let updatedAt: String?
}

struct SaveList: Encodable {
    let title: String
    let color: String
}

struct SavePlacesPayload: Encodable {
    let placeIds: [Int]
    let waybleZoneId: Int
}

public enum UserPlaceSort: String, Sendable {
    case latest
    case name
}

struct SimpleSavedPlaceResponse: Decodable, Identifiable {
    let placeId: Int
    let title: String
    let color: String
    let savedCount: Int

    var id: Int { placeId }
}

struct PlaceListResponse: Decodable {
    let placeId: Int
    let title: String
    let color: String
    let message: String
}

// 페이지네이션 (MapSearch 등에서 사용)

struct Page<T: Decodable & Sendable>: Decodable {
    let content: [T]
    let pageable: Pageable?
    // 필요 시 totalElements/totalPages 추가 가능
}

struct Pageable: Decodable {
    let pageNumber: Int?
    let pageSize: Int?
    let offset: Int?
    let paged: Bool?
    let unpaged: Bool?
    let sort: SortInfo?
}

struct SortInfo: Decodable {
    let sorted: Bool?
    let unsorted: Bool?
    let empty: Bool?
}

// MARK: - 리뷰

struct ReviewListResponse: Codable {
    let data: [Review]
}

struct Review: Identifiable, Codable {
    let id: Int
    let userNickname: String
    let rating: Double      // 서버가 5.0처럼 Double로 내려주므로 Double이어야 함
    let content: String
    let visitDate: String
    let likes: Int
    let images: [String]

    enum CodingKeys: String, CodingKey {
        case id = "reviewId"
        case userNickname
        case rating
        case content
        case visitDate
        case likes
        case images
    }
}

struct ReviewPostRequestModel: Encodable {
    let content: String
    let rating: Int
    let visitDate: String
    let facilities: [String]  // 상세와 다르게 문자열 배열
    let images: [String]?     // 업로드 후 URL 문자열들
}

struct UploadImagesBody: Codable {
    let images: [String]
}

// MARK: - TOP 3 (즐겨찾기/인기 존)

struct FavoritesWaybleZoneResponse: Decodable {
    let data: [FavoritesWaybleZone]
}

struct FavoritesWaybleZone: Decodable {
    let waybleZoneInfo: FavWaybleZoneInfo
}

struct FavWaybleZoneInfo: Decodable, Identifiable {
    let id: Int
    let name: String
    let category: String
    let imageUrl: String?
    let address: String
    let latitude: Double
    let longitude: Double
    let rating: Double
    let reviewCount: Int
    let facilities: Facilities

    enum CodingKeys: String, CodingKey {
        case id = "zoneId"
        case name = "zoneName"
        case category = "zoneType"
        case imageUrl = "thumbnailImageUrl"
        case address
        case latitude
        case longitude
        case rating = "averageRating"
        case reviewCount
        case facilities = "facility"
    }
}
