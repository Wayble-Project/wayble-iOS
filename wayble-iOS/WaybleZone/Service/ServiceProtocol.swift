import Foundation

protocol WaybleZoneServiceProtocol {
    func fetchPlaceDetail(city: String, category: String) async throws -> WaybleZone
}

protocol ZoneDetailServiceProtocol {
    func fetchZoneDetail(id: Int) async throws -> WaybleZone
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

// protocol FilesServiceProtocol {
//    func uploadImagesBase64(_ imagesBase64: [String]) async throws -> [String]
//}

protocol FilesServiceProtocol {
    func uploadImagesMultipart(_ datas: [Data]) async throws -> [String]
}

 protocol UserPlaceServiceProtocol {
    func saveList(_ payload: SaveList) async throws
    func savePlaces(_ payload: SavePlacesPayload) async throws
    func deletePlace(placeId: Int, waybleZoneId: Int) async throws
    func fetchSimpleSavedPlaces(sort: UserPlaceSort) async throws -> [SimpleSavedPlaceResponse]
    func fetchPlaces(placeId: Int, page: Int, size: Int) async throws -> Page<WaybleZone>
}

protocol WaybleZoneMapSearchServiceProtocol {
    func searchMaps(
        latitude: Double,
        longitude: Double,
        radiusKm: Double?,
        zoneName: String?,
        zoneType: ZoneType?,
        page: Int,
        size: Int
    ) async throws -> Page<WaybleZoneMapSearchItem>
}
