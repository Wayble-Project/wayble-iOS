import Foundation

protocol WaybleZoneServiceProtocol {
    func fetchPlaceDetail(city: String, category: String) async throws -> WaybleZone
}

protocol ReviewServiceProtocol {
    func fetchReviews(for zoneID: Int, sort: ReviewSort) async throws -> [Review]
}
