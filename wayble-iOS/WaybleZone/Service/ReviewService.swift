import Foundation

struct ReviewService: ReviewServiceProtocol {
    private let apiClient: AuthAPIClient
    
    init(apiClient: AuthAPIClient = AuthAPIClient()) {
        self.apiClient = apiClient
    }

    func fetchReviews(for zoneID: Int, sort: ReviewSort) async throws -> [Review] {
        let request = ReviewRequest(zoneID: zoneID, sort: sort)
        let response: ReviewListResponse = try await apiClient.send(request)
        return response.data
    }
}


struct ReviewPostService: ReviewPostServiceProtocol {
    private let apiClient: AuthAPIClient
    
    init(apiClient: AuthAPIClient = AuthAPIClient()) {
        self.apiClient = apiClient
    }
    
    func postReview(waybleZoneId: Int, review: ReviewPostRequest) async throws {

            // 응답을 반환하지 않으므로
            _ = try await apiClient.send(review)
        }
}
