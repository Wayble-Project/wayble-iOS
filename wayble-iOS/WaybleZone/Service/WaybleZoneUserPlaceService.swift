import Foundation


final class WaybleZoneUserPlaceService: UserPlaceServiceProtocol {
    private let apiClient: AuthAPIClient
    
    init(apiClient: AuthAPIClient = AuthAPIClient()) {
        self.apiClient = apiClient
    }
    
    
    func saveList(_ payload: SaveList) async throws {
        let request = UsersSaveListRequest(payload: payload)
        _ = try await apiClient.send(request)
    }
    
    func savePlaces(_ payload: SavePlacesPayload) async throws {
        let request = SavePlacesRequest(payload: payload)
        _ = try await apiClient.send(request)
    }
    
    func deletePlace(placeId: Int, waybleZoneId: Int) async throws {
        let request = UsersPlaceDeleteRequest(placeId: placeId, waybleZoneId: waybleZoneId)
        _ = try await apiClient.send(request)
        
    }
    
    func fetchSimpleSavedPlaces(sort: UserPlaceSort = .latest) async throws -> [SimpleSavedPlaceResponse] {
        let request = SimpleUsersPlaceListRequest(sort: sort)
        let res: SimpleAPIResponse<[SimpleSavedPlaceResponse]> = try await apiClient.send(request)
        return res.data
    }
    
    func fetchPlaces(
        placeId: Int,
        page: Int = 1,
        size: Int = 20
    ) async throws -> Page<WaybleZone> {
        let req = UsersPlaceZonesListRequest(placeId: placeId, page: page, size: size)
        let res: SimpleAPIResponse<Page<WaybleZone>> = try await apiClient.send(req)
        print("res.data", res.data)
        return res.data
    }
}
