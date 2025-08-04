import Foundation


final class FavoritesWaybleZoneService: FavoritesWaybleZoneServiceProtocol {
    
    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }
    

    func fetchFavoritesZones(in district: String) async throws -> [FavoritesWaybleZone] {
        let request = FavoritesWaybleZoneRequest(district: district)
        let response = try await apiClient.send(request)
        return response.data
    }
}
