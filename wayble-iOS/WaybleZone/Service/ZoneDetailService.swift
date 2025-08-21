
import Foundation

final class ZoneDetailService: ZoneDetailServiceProtocol {

    private let apiClient: AuthAPIClient
    
    init(apiClient: AuthAPIClient = AuthAPIClient()) {
        self.apiClient = apiClient
    }
    
    func fetchZoneDetail(id waybleZoneId: Int) async throws -> WaybleZone {
            let request = ZoneDetailRequest(waybleZoneId: waybleZoneId)
            let response = try await apiClient.send(request)
        //대신 APIClient().send 이렇게 쓰면xxx
            return response.data
        }

    
}
