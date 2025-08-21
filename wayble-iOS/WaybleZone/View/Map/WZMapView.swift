

struct WZMainTopBar: View {
    @Binding var selectedIndex: Int
    var onCategorySelect: (ZoneType?) -> Void = { _ in }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                WZMainSearchBar(selectedIndex: $selectedIndex)
                Spacer()
                Button {
                    withAnimation { selectedIndex = 19 }
                } label: {
                    HeartButton()
                }
            }
            .padding(.top, 10)
            .padding(.bottom, 14)
            .padding(.trailing, 20)

            WZTopCategoryBar(onSelect: onCategorySelect)
                .padding(.bottom, 21)
        }
        .padding(.leading, 20)
    }
}

import SwiftUI
import NMapsMap
import CoreLocation

// MARK: - 메인 지도 화면

struct WZMainMapView: View {

    // 설비(편의시설) 마커 로딩용 (기존 유지)
    @StateObject private var facilityVM = MainMapViewModel()

    // 지도 기반 웨이블존 검색용 (@Observable 기반이라 @State로 보유)
    @State private var searchVM = MapSearchViewModel()

    // 카메라 초기 위치(프로퍼티로는 "초기값"만 넘기고, 이후 이동은 onLocationChanged로만 처리)
    @State private var initialCenter: NMGLatLng = .init(lat: 37.543861, lng: 126.951028) // 공덕역
    // 현재 지도 중심(우리 로직에서만 사용; NaverMapView centerX/centerY로는 넘기지 않음)
    @State private var mapCenter: NMGLatLng = .init(lat: 37.543861, lng: 126.951028)

    @Binding var selectedIndex: Int
    @Binding var selectedPlaceID: Int?

    // 지도 중심 변경 디바운스
    @State private var centerUpdateTask: Task<Void, Never>?
    // 최초 1회만 초기 검색하도록 플래그
    @State private var didLoadOnce = false
    // 마지막으로 검색 질의했던 좌표(사소한 이동 무시용)
    @State private var lastQueryCoord: CLLocationCoordinate2D?

    var body: some View {
        VStack(spacing: 0) {
            // 상단 (검색바 + 좋아요 + 카테고리 칩)
            WZMainTopBar(selectedIndex: $selectedIndex) { zoneType in
                Task {
                    searchVM.zoneType = zoneType
                    await searchVM.refresh()
                }
            }

            // 지도
            ZStack {
                NaverMapView(
                    // ✅ 피드백 루프 차단: centerX/centerY에는 "초기값"만 전달
                    centerX: initialCenter.lng,
                    centerY: initialCenter.lat,
                    onLocationChanged: { newLat, newLng in
                        // 내부 상태 업데이트(우리 로직용)
                        mapCenter = .init(lat: newLat, lng: newLng)

                        // ➊ 사소한 이동 무시 (예: 60m 미만은 무시)
                        let newCoord = CLLocationCoordinate2D(latitude: newLat, longitude: newLng)
                        if let last = lastQueryCoord, newCoord.distance(to: last) < 60 {
                            return
                        }
                        lastQueryCoord = newCoord

                        // ➋ 디바운스 후 단일 검색
                        centerUpdateTask?.cancel()
                        centerUpdateTask = Task { @MainActor in
                            try? await Task.sleep(nanoseconds: 350_000_000) // 350ms
                            searchVM.latitude = newLat
                            searchVM.longitude = newLng
                            await searchVM.refresh()
                        }
                    },
                    zoomLevel: 17,
                    showMarker: true,
                    facilities: mapPins // ✅ 검색 결과 + 편의시설 마커를 함께 전달
                )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.container, edges: .bottom)

            // 검색 결과 리스트 (기존 카드 재사용)
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(searchVM.items, id: \.waybleZoneInfo.zoneId) { item in
                        WaybleZoneCard(zone: toWaybleZone(item), selectedIndex: $selectedIndex,
                                       selectedPlaceID: $selectedPlaceID)
                            .onAppear {
                                // 무한 스크롤
                                if item.waybleZoneInfo.zoneId == searchVM.items.last?.waybleZoneInfo.zoneId {
                                    Task { await searchVM.loadMore() }
                                }
                            }
                            .padding(.bottom, 16)
                    }

                    if searchVM.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    }
                }
                .padding(.top, 16)
                .background(Color("gray-100"))
            }
            .refreshable { await searchVM.refresh() }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .appToast($searchVM.errorMessage)
        .task {
            // ✅ 최초 1회만 초기 로드
            guard !didLoadOnce else { return }
            didLoadOnce = true

            // 초기 좌표 → 검색 파라미터 반영
            searchVM.latitude = mapCenter.lat
            searchVM.longitude = mapCenter.lng
            // 반경 기본값(너무 크면 과도 로딩) — 필요에 맞게 조정
            if searchVM.radiusKm == nil { searchVM.radiusKm = 0.8 }

            await searchVM.refresh()
        }
    }

    // 현재 중심값(우리 로직용; NaverMapView에는 initialCenter만 넘김)
    private var centerLat: Double { mapCenter.lat }
    private var centerLng: Double { mapCenter.lng }

    // ✅ 지도에 넘길 마커 통합:
    // - 기존 편의시설 마커(facilityVM.homeFacilities)
    // - 검색 결과(searchVM.items)를 핀으로 변환
    private var mapPins: [HomeFacility] {
       // let facilityPins = facilityVM.homeFacilities
        let zonePins = searchVM.items.map { item in
            let i = item.waybleZoneInfo
            return HomeFacility(
                latitude: i.latitude ?? 0,
                longitude: i.longitude ?? 0,
                facilityType: i.zoneType.rawValue   // "CAFE" or "RESTAURANT"
            )
        }
       // return facilityPins + zonePins
        return zonePins
    }

    // 검색 아이템 → 카드 모델 매핑 (필수 필드 기본값 보정)
    private func toWaybleZone(_ item: WaybleZoneMapSearchItem) -> WaybleZone {
        let info = item.waybleZoneInfo
        let fac = Facilities(from: info.facility)

        return WaybleZone(
            id: info.zoneId,                           // CodingKeys에서 waybleZoneId 매핑
            name: info.zoneName,
            category: info.zoneType.rawValue,          // "CAFE" / "RESTAURANT"
            address: info.address,
            rating: info.averageRating,
            reviewCount: info.reviewCount,
            contactNumber: "",                         // 목록 응답에 없으므로 기본값
            imageUrl: info.thumbnailImageUrl ?? "",    // non-optional 보정
            facilities: fac,
            businessHours: [:],                        // 목록 응답에 없음
            photos: info.thumbnailImageUrl.map { [$0] } ?? [],
            latitude: info.latitude,
            longitude: info.longitude
        )
    }
}

// MARK: - Facilities 보정 (Search 응답 → 상세 모델)
fileprivate extension Facilities {
    init(from s: WaybleZoneMapSearchItem.Info.SearchFacility?) {
        self.init(
            hasSlope: s?.hasSlope ?? false,
            hasNoDoorStep: s?.hasNoDoorStep ?? false,
            hasElevator: s?.hasElevator ?? false,
            hasTableSeat: s?.hasTableSeat ?? false,
            hasDisabledToilet: s?.hasDisabledToilet ?? false,
            floorInfo: s?.floorInfo ?? ""
        )
    }
}

// MARK: - 좌표 거리 계산 헬퍼 (threshold 용)
private extension CLLocationCoordinate2D {
    func distance(to other: Self) -> CLLocationDistance {
        CLLocation(latitude: latitude, longitude: longitude)
            .distance(from: CLLocation(latitude: other.latitude, longitude: other.longitude))
    }
}
