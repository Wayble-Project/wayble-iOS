import Foundation


final class SearchRankWaybleZoneService: SearchRankWaybleZoneServiceProtocol {
    
    private let apiClient: AuthAPIClient

    init(apiClient: AuthAPIClient = AuthAPIClient()) {
        self.apiClient = apiClient
    }
    
    

    func fetchTopSearchedZones(in district: String) async throws -> [FavoritesWaybleZone] {
        let request = FavoritesWaybleZoneRequest(district: district)
        let response = try await apiClient.send(request)
        return response.data
    }
}
