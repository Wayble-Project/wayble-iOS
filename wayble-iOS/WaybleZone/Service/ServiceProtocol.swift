import Foundation

protocol WaybleZoneServiceProtocol {
    func fetchPlaceDetail(city: String, category: String) async throws -> WaybleZone
}

protocol ReviewServiceProtocol {
    func fetchReviews(for zoneID: Int, sort: ReviewSort) async throws -> [Review]
}

protocol ReviewPostServiceProtocol {
    func postReview(waybleZoneId: Int, review: ReviewPostRequest) async throws
}

protocol FavoritesWaybleZoneServiceProtocol {
    func fetchFavoritesZones(in district: String) async throws -> [FavoritesWaybleZone]
}

protocol SearchRankWaybleZoneServiceProtocol {
    func fetchTopSearchedZones(in district: String) async throws -> [FavoritesWaybleZone]
}

//public protocol FilesServiceProtocol {
//    func uploadImages(_ images: [ImagePart]) async throws -> [String]
//}

//public protocol UserPlaceServiceProtocol {
//    func createUserPlace(waybleZoneId: Int, title: String) async throws -> UserPlace
//    func fetchUserPlaces() async throws -> [UserPlace]
//}
