import SwiftUI

struct PlaceDetailView: View {
    @Bindable var vm: PlaceDetailViewModel
    @State private var sortLabel: String = "추천순"
    @Binding var selectedIndex: Int
    @Binding var writeReviewPlace: PlaceIdent?

    var body: some View {
        ScrollView {
            VStack {
                if let zone = vm.waybleZone {
                    PlaceDetailHeaderView(
                        waybleZone: zone,
                        place: PlaceModel(
                            title: zone.name,
                            roadAddress: zone.address,
                            x: "\(zone.longitude)",  // ← 실제 좌표
                            y: "\(zone.latitude)",
                            category: zone.category
                        ),
                        selectedIndex: $selectedIndex
                    )
                    PlaceInfoView(waybleZone: zone)
                    PlaceReView(
                        selected: $sortLabel,
                        waybleZone: zone,
                        reviews: vm.reviews,
                        selectedIndex: $selectedIndex,
                        writeReviewPlace: $writeReviewPlace
                    )
                }
            }
        }
        // zoneID가 바뀌면 자동 재요청
        .task(id: vm.zoneID) {
            await vm.fetchZoneDetail()
            await vm.fetchReviews(zoneID: vm.zoneID, sort: sortLabel.toReviewSort())
        }
        .task(id: sortLabel) {
            await vm.fetchReviews(zoneID: vm.zoneID, sort: sortLabel.toReviewSort())
        }
    }
}

private extension String {
    func toReviewSort() -> ReviewSort {
        switch self {
        case "추천순": return .rating
        case "최신순": return .latest
        default:       return .latest
        }
    }
}
