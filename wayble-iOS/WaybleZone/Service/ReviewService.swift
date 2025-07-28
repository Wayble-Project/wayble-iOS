import Foundation

final class ReviewService: ReviewServiceProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient = APIClient()) {
        self.apiClient = apiClient
    }

    func fetchReviews(for zoneID: Int, sort: ReviewSort) async throws -> [Review] {
        let request = ReviewRequest(zoneID: zoneID, sort: sort)
        let response: ReviewListResponse = try await apiClient.send(request)
        return response.data
    }
}
