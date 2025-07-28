import Foundation

final class WaybleZoneService: WaybleZoneServiceProtocol {
   // private let apiClient = APIClient()
    
    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchPlaceDetail(city: String, category: String) async throws -> WaybleZone {
        let request = WaybleZoneRequest(city: city, category: category)
        let response = try await apiClient.send(request)
        return response.data
    }
}
