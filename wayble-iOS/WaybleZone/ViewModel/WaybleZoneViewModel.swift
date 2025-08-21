import SwiftUI
import Observation
import PhotosUI
import CoreLocation
import UIKit

// WaybleZone 상세페이지
enum FacilityOption: String, CaseIterable, Identifiable {
    case hasNoDoorStep = "문턱 없음"
    case floorInfo = "1F 1층"
    case kindStaff = "직원이 친절해요"
    case hasTableSeat = "테이블석"
    case hasDisabledToilet = "장애인 화장실"
    case hasSlope = "경사로"
    case hasElevator = "엘리베이터"
    
    var id: String { self.rawValue } //.id(\.self) 이거 안 써도 됨
    
    var iconName: String {
        switch self {
        case .hasNoDoorStep: return "door"
        case .floorInfo: return ""
        case .kindStaff: return ""
        case .hasTableSeat: return "table"
        case .hasDisabledToilet: return "chair02"
        case .hasSlope: return "chair01"
        case .hasElevator : return "lift"
        }
    }
}


//MARK: 리뷰 작성 할때 FacilitySelection
@Observable
class FacilitySelectionViewModel {
    var selected: Set<FacilityOption> = []
    var selectedFloorInfo: String = "1F 1층"
    
    func toggle(_ option: FacilityOption) {
        if selected.contains(option) {
            selected.remove(option)
        } else {
            selected.insert(option)
        }
    }
    
    var facilities: Facilities {
        Facilities(
            hasSlope: selected.contains(.hasSlope),
            hasNoDoorStep: selected.contains(.hasNoDoorStep),
            hasElevator: selected.contains(.hasElevator),
            hasTableSeat: selected.contains(.hasTableSeat),
            hasDisabledToilet: selected.contains(.hasDisabledToilet),
            floorInfo: selected.contains(.floorInfo) ? selectedFloorInfo : ""
        )
    }
    //mock 데이터 넣어보기용 함수
    //api 연결시 삭제
    func loadMockData() {
        let mock = mockWaybleZoneResponse.data.facilities
        
        if mock!.hasSlope { selected.insert(.hasSlope) }
        if mock!.hasNoDoorStep { selected.insert(.hasNoDoorStep) }
        if mock!.hasElevator { selected.insert(.hasElevator) }
        if mock!.hasTableSeat { selected.insert(.hasTableSeat) }
        if mock!.hasDisabledToilet { selected.insert(.hasDisabledToilet) }
        if !mock!.floorInfo.isEmpty {
            selected.insert(.floorInfo)
            selectedFloorInfo = mock!.floorInfo
        }
    }
    var mockZone: WaybleZone {
        return mockWaybleZoneResponse.data
    }
}



@Observable
@MainActor
final class PlaceDetailViewModel {
    let zoneID: Int
    var waybleZone: WaybleZone? = nil
    var reviews: [Review] = []
    
    //var isLoadingReviews: Bool = false
    //var reviewErrorMessage: String? = nil
    
    private let zoneService: any ZoneDetailServiceProtocol
    private let FavoritesZonesService: any FavoritesWaybleZoneServiceProtocol
    private let reviewService: any ReviewServiceProtocol
    
    init(zoneService: any ZoneDetailServiceProtocol = ZoneDetailService(),
         zoneID: Int,
         reviewService: any ReviewServiceProtocol = ReviewService(),
         FavoritesZonesService: any FavoritesWaybleZoneServiceProtocol = FavoritesWaybleZoneService()
    ) {
        self.zoneService = zoneService
        self.zoneID = zoneID
        self.reviewService = reviewService
        self.FavoritesZonesService = FavoritesZonesService
    }
    
    func fetchZoneDetail() async {
        do {
            self.waybleZone = try await zoneService.fetchZoneDetail(id: zoneID)
        } catch {
            print("Error fetching detail: \(error.localizedDescription)")
        }
    }
    
    
    func fetchReviews(zoneID: Int, sort: ReviewSort = .latest) async {
        //isLoadingReviews = true
        //defer { isLoadingReviews = false }
        
        do {
            self.reviews = try await reviewService.fetchReviews(for: zoneID, sort: sort)
        } catch {
            //self.reviewErrorMessage = error.localizedDescription
            print("Error fetching Reviews: \(error.localizedDescription)")
        }
    }
    
}




@Observable
final class TopPlaceViewModel {
    enum Category: String, CaseIterable, Identifiable {
        case favorite = "즐겨찾기 순"
        case search = "검색순"
        var id: Self { self }
    }
    
    //TODO: 디폴트 현재위치로 수정하기
    @ObservationIgnored
    @AppStorage("selectedDong") private var selectedDong: String = "서초동"
    
    private let FavoritesZonesService: any FavoritesWaybleZoneServiceProtocol
    private let searchRankService: any SearchRankWaybleZoneServiceProtocol
    
    init(FavoritesZonesService: any FavoritesWaybleZoneServiceProtocol = FavoritesWaybleZoneService(),
         searchRankService: any SearchRankWaybleZoneServiceProtocol = SearchRankWaybleZoneService()
    ) {
        self.FavoritesZonesService = FavoritesZonesService
        self.searchRankService = searchRankService
    }
    
    var selected: Category = .favorite {
        willSet {
            Task { await fetchTop3(for: newValue) }
        }
    }
    
    var top3Zones: [FavWaybleZoneInfo] = []
    
    func fetchTop3(for category: Category) async {
        do {
            switch category {
            case .favorite:
                let result = try await FavoritesZonesService.fetchFavoritesZones(in: selectedDong)
                self.top3Zones = result.prefix(3).map { $0.waybleZoneInfo }
            case .search:
                let result = try await searchRankService.fetchTopSearchedZones(in: selectedDong)
                self.top3Zones = result.prefix(3).map { $0.waybleZoneInfo }
            }
        }catch is CancellationError {
            return
        } catch let urlErr as URLError where urlErr.code == .cancelled {
            return
        } catch {
            print("Top3 fetch Error: \(error)")
            self.top3Zones = []
        }
        
       
    }
}

//MARK: 리뷰 작성

//enum ImageProcessError: LocalizedError {
//    case decodeFailed
//    case reencodeFailed
//
//    var errorDescription: String? {
//        switch self {
//        case .decodeFailed:  return "이미지 디코딩에 실패했습니다."
//        case .reencodeFailed: return "이미지 재인코딩에 실패했습니다."
//        }
//    }
//}
//
//@MainActor
//@Observable
//final class WriteReviewViewModel {
//    
//    var isSubmitting = false
//    var submitError: Error?
//    var successMessage: String?
//    
//    private let service: ReviewPostServiceProtocol
//    private let filesService: FilesServiceProtocol
//    
//    init(service: ReviewPostServiceProtocol = ReviewPostService(),
//         filesService: FilesServiceProtocol = FilesService()) {
//        self.service = service
//        self.filesService = filesService
//    }
//    
//    // MARK: Base64 이미지 업로드
////    private func base64(from item: PhotosPickerItem) async throws -> String {
////        guard let data = try await item.loadTransferable(type: Data.self) else {
////            throw URLError(.cannotDecodeContentData)
////        }
////        return data.base64EncodedString()
////    }
//    
//    // WriteReviewViewModel 내부
//    private func base64(from item: PhotosPickerItem) async throws -> String {
//          // 1) Data로 로드 (가장 호환성 높음)
//          guard let data = try await item.loadTransferable(type: Data.self) else {
//              throw ImageProcessError.decodeFailed
//          }
//
//          // 2) UIImage 복원
//          guard let uiImage = UIImage(data: data) else {
//              // 원본이 이미지가 아니거나 손상된 경우
//              throw ImageProcessError.decodeFailed
//          }
//
//          // 3) JPEG로 재인코딩(품질 0.8)
//          guard let jpeg = uiImage.jpegData(compressionQuality: 0.8) else {
//              // JPEG 변환 실패 시: 원본을 그대로 base64로 보내고 싶다면
//              // return "data:image/png;base64," + data.base64EncodedString()
//              // 처럼 fallback을 두어도 됩니다. (원본이 PNG/HEIC일 수 있음)
//              throw ImageProcessError.reencodeFailed
//          }
//
//          // 4) Base64 + MIME prefix
//          return "data:image/jpeg;base64," + jpeg.base64EncodedString()
//      }
//
//    
//    
//    private func base64s(from items: [PhotosPickerItem]) async throws -> [String] {
//        try await withThrowingTaskGroup(of: String.self) { group in
//            for it in items {
//                group.addTask { try await self.base64(from: it) }
//            }
//            var out: [String] = []
//            for try await s in group { out.append(s) }
//            return out
//        }
//    }
//    
//    func submit(zoneID: Int,
//                form: ReviewPostRequestModel,
//                photoItems: [PhotosPickerItem]?
//    ) async {
//        isSubmitting = true
//        submitError = nil
//        successMessage = nil
//        defer { isSubmitting = false }
//        
//        do {
//            var finalForm = form
//            
//            if let items = photoItems, !items.isEmpty {
//                let base64List = try await base64s(from: items)
//               // print("🟦 base64 count:", base64List.count, "first len:", base64List.first?.count ?? 0)
//                let uploadedURLs = try await filesService.uploadImagesBase64(base64List)
//              //  print("🟩 uploaded URLs:", uploadedURLs)
//                finalForm = ReviewPostRequestModel(
//                    content: form.content,
//                    rating: form.rating,
//                    visitDate: form.visitDate,
//                    facilities: form.facilities,
//                    images: uploadedURLs
//                )
//            }
//            
//            
//            let request = ReviewPostRequest(zoneID: zoneID, payload: finalForm)
//            try await service.postReview(waybleZoneId: zoneID, review: request)
//            successMessage = "리뷰가 등록되었습니다!"
//            
//        } catch is CancellationError {
//            // 유저가 화면을 벗어나는 등 작업이 취소된 경우 조용히 종료
//            return
//        } catch {
//            submitError = error
//        }
//    }
//}



@MainActor
@Observable
final class WriteReviewViewModel {

    var isSubmitting = false
    var submitError: Error?
    var successMessage: String?

    private let service: ReviewPostServiceProtocol
    private let filesService: FilesServiceProtocol

    init(service: ReviewPostServiceProtocol = ReviewPostService(),
         filesService: FilesServiceProtocol = FilesService()) {
        self.service = service
        self.filesService = filesService
    }

    // MARK: - PhotosPickerItem -> 반드시 JPEG(Data)
    private func jpegData(from item: PhotosPickerItem) async throws -> Data {
        // Data 로드
        guard let raw = try await item.loadTransferable(type: Data.self) else {
            throw ImageProcessError.decodeFailed
        }
        // UIImage 복원
        guard let ui = UIImage(data: raw) else {
            throw ImageProcessError.decodeFailed
        }
        // ✅ 반드시 JPEG로 재인코딩(서버에 JPEG로 보냄)
        guard let jpg = ui.jpegData(compressionQuality: 0.85) else {
            throw ImageProcessError.reencodeFailed
        }
        return jpg
    }

    private func jpegDatas(from items: [PhotosPickerItem]) async throws -> [Data] {
        try await withThrowingTaskGroup(of: Data.self) { group in
            for it in items {
                group.addTask { try await self.jpegData(from: it) }
            }
            var out: [Data] = []
            for try await d in group { out.append(d) }
            return out
        }
    }

    // MARK: - Submit: multipart/form-data -> URL 수신 -> 리뷰 등록
    func submit(zoneID: Int,
                form: ReviewPostRequestModel,
                photoItems: [PhotosPickerItem]?
    ) async {
        isSubmitting = true
        submitError = nil
        successMessage = nil
        defer { isSubmitting = false }

        do {
            var finalForm = form

            if let items = photoItems, !items.isEmpty {
                let datas = try await jpegDatas(from: items)
                print("🟦 JPEG datas count = \(datas.count)")
                for (i, d) in datas.enumerated() {
                    print("   • [\(i)] \(d.count / 1024) KB")
                }

                let uploadedURLs = try await filesService.uploadImagesMultipart(datas)
                print("🟩 uploaded URLs = \(uploadedURLs)")

                finalForm = ReviewPostRequestModel(
                    content: form.content,
                    rating: form.rating,
                    visitDate: form.visitDate,
                    facilities: form.facilities,
                    images: uploadedURLs
                )
            } else {
                print("ℹ️ no images to upload")
            }

            let request = ReviewPostRequest(zoneID: zoneID, payload: finalForm)
            try await service.postReview(waybleZoneId: zoneID, review: request)
            print("✅ review posted")
            successMessage = "리뷰가 등록되었습니다!"

        } catch is CancellationError {
            return
        } catch {
            print("❌ submit error:", error.localizedDescription)
            submitError = error
        }
    }
}

enum ImageProcessError: LocalizedError {
    case decodeFailed
    case reencodeFailed
    var errorDescription: String? {
        switch self {
        case .decodeFailed: return "이미지 디코드에 실패했습니다."
        case .reencodeFailed: return "JPEG 재인코드에 실패했습니다."
        }
    }
}


//MARK: SAVED PLACES

@MainActor
@Observable
final class UserPlaceViewModel {
    private let service: UserPlaceServiceProtocol
    
    var isSaving = false
    var errorMessage: String?
    var successMessage: String?
    var places: [SimpleSavedPlaceResponse] = []
    
    var pageable: Pageable?
    var zones: [WaybleZone] = []
    
    
    init(service: UserPlaceServiceProtocol = WaybleZoneUserPlaceService()) {
        self.service = service
    }
    
    func fetch(sort: UserPlaceSort = .latest) async {
        //isSaving = true
        errorMessage = nil
        successMessage = nil
        do {
            places = try await service.fetchSimpleSavedPlaces(sort: sort)
            
            print("✅ fetched places count =", places.count)
        }  catch is CancellationError {
            return
        } catch let urlErr as URLError where urlErr.code == .cancelled { // ✅ 적용: -999 무시
            return
        } catch {
            errorMessage = error.localizedDescription
            print("❌ fetch error:", error.localizedDescription)
        }
        //isSaving = false
    }
    
    func loadZones(placeId: Int, page: Int = 1, size: Int = 20) async {
        //isSaving = true
        errorMessage = nil
        successMessage = nil
        do {
            let pageData = try await service.fetchPlaces(placeId: placeId, page: page, size: size)
            guard !Task.isCancelled else { return }
            zones = pageData.content
            pageable = pageData.pageable
        } catch is CancellationError {
            return
        } catch let urlErr as URLError where urlErr.code == .cancelled { 
            return
        } catch {
            errorMessage = error.localizedDescription
        }
        //isSaving = false
    }
    
    //place
    func PlaceSave(placeIds: [Int], waybleZoneId: Int) async {
            guard !placeIds.isEmpty else {
                errorMessage = "선택된 리스트가 없습니다"
                return
            }

            isSaving = true
            errorMessage = nil
            successMessage = nil
            defer { isSaving = false }

            do {
                let payload = SavePlacesPayload(placeIds: placeIds, waybleZoneId: waybleZoneId)
                try await service.savePlaces(payload)
                successMessage = "장소가 저장되었습니다"
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    
    
    //list
    func save(title: String, color: String) async {
        isSaving = true
        errorMessage = nil
        successMessage = nil
        do {
            let payload = SaveList( title: title, color: color)
            try await service.saveList(payload)
            successMessage = "리스트가 저장되었습니다."
        } catch {
            errorMessage = error.localizedDescription
        }
        isSaving = false
    }
    
    func remove(placeId: Int, waybleZoneId: Int) async {
        //isSaving = true
        errorMessage = nil
        successMessage = nil
        do {
            try await service.deletePlace(placeId: placeId, waybleZoneId: waybleZoneId)
            successMessage = "장소가 삭제되었습니다."
            // 여기서 로컬 상태의 savedCount/likes를 -1 반영
            // self.savedCount -= 1; self.likes -= 1
        } catch {
            errorMessage = error.localizedDescription
        }
        //isSaving = false
    }
    
}

//MARK: SEARCH


enum ZoneType: String, Codable {
    case RESTAURANT, CAFE
}

struct WaybleZoneMapSearchItem: Decodable {
    struct Info: Decodable {
        let zoneId: Int
        let zoneName: String
        let zoneType: ZoneType
        let thumbnailImageUrl: String?
        let address: String
        let latitude: Double?
        let longitude: Double?
        let averageRating: Double
        let reviewCount: Int
        let facility: SearchFacility?
        
        struct SearchFacility: Decodable {
            let hasSlope: Bool
            let hasNoDoorStep: Bool
            let hasElevator: Bool
            let hasTableSeat: Bool
            let hasDisabledToilet: Bool
            let floorInfo: String?
        }
    }
    
    let waybleZoneInfo: Info
    /// km 단위 거리
    let distance: Double
}


extension LocationManager {
    func requestOneShotLocation() async -> CLLocationCoordinate2D? {
        await withCheckedContinuation { cont in
            self.requestLocation { coord in
                cont.resume(returning: coord)
            }
        }
    }
}

//
//@MainActor
//@Observable
//final class MapSearchViewModel {
//    private let service: WaybleZoneMapSearchServiceProtocol
//    
//    
//    var items: [WaybleZoneMapSearchItem] = []
//    var pageable: Pageable?
//    var isLoading = false
//    var errorMessage: String?
//    
//    private var queryCoordinate: CLLocationCoordinate2D?
//    
//    var latitude: Double = 37.4951233
//    var longitude: Double = 127.045
//    var radiusKm: Double? = nil
//    var zoneName: String? = nil
//    var zoneType: ZoneType? = nil
//    var page: Int = 0
//    var size: Int = 30
//    
//    init(service: WaybleZoneMapSearchServiceProtocol = WaybleZoneMapSearchService()) {
//        self.service = service
//    }
//    
//    func refresh() async {
//        page = 0
//        items.removeAll()
//        
//        if let coord = await LocationManager.shared.requestOneShotLocation() {
//            queryCoordinate = coord
//            // 원한다면 공개 state도 동기화
//            latitude = coord.latitude
//            longitude = coord.longitude
//        } else {
//            // 권한 거부/실패 → 폴백 좌표로 고정
//            queryCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
//            errorMessage = "현재 위치를 가져오지 못했습니다. 기본 위치로 검색합니다."
//        }
//        
//        await loadMore()
//    }
//    
//    func loadMore() async {
//        guard !isLoading else { return }
//        isLoading = true
//        defer { isLoading = false }
//        
//        //캐싱
//        let lat = queryCoordinate?.latitude ?? latitude
//        let lon = queryCoordinate?.longitude ?? longitude
//        
//        do {
//            let pageData = try await service.searchMaps(
//                latitude: lat,
//                longitude: lon,
//                radiusKm: radiusKm,
//                zoneName: zoneName,
//                zoneType: zoneType,
//                page: page,
//                size: size
//            )
//            items += pageData.content
//            pageable = pageData.pageable
//            page += 1 // 무한 스크롤: 다음 페이지 준비
//        } catch {
//            errorMessage = error.localizedDescription
//        }
//    }
//}

@MainActor
@Observable
final class MapSearchViewModel {
    private let service: WaybleZoneMapSearchServiceProtocol

    var items: [WaybleZoneMapSearchItem] = []
    var pageable: Pageable?
    var isLoading = false
    var errorMessage: String?

    private var queryCoordinate: CLLocationCoordinate2D?

    var latitude: Double = 37.543861
    var longitude: Double = 126.951028
    var radiusKm: Double? = nil
    var zoneName: String? = nil
    var zoneType: ZoneType? = nil
    var page: Int = 0
    var size: Int = 30

    init(service: WaybleZoneMapSearchServiceProtocol = WaybleZoneMapSearchService()) {
        self.service = service
    }

    // 콜백 기반 LocationManager를 async/await로 감싸는 브리지 (타임아웃 포함)
    private func getCurrentLocation(timeout seconds: TimeInterval = 6.0) async -> CLLocationCoordinate2D? {
        await withCheckedContinuation { cont in
            // 여러 번 resume되는 사고 대비
            var didResume = false
            func safeResume(_ coord: CLLocationCoordinate2D?) {
                if didResume { return }
                didResume = true
                cont.resume(returning: coord)
            }

            // 콜백 기반 요청
            LocationManager.shared.requestLocation { coord in
                // 메인에서 상태 만지는 걸 가정하니 안전하게 MainActor로
                Task { @MainActor in
                    safeResume(coord)
                }
            }

            // 타임아웃 보호막: 실패/미응답시 nil로 종료
            Task {
                try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
                await MainActor.run {
                    safeResume(nil)
                }
            }
        }
    }

    func refresh() async {
        page = 0
        items.removeAll()
        errorMessage = nil

        if let coord = await getCurrentLocation() {
            queryCoordinate = coord
            latitude = coord.latitude
            longitude = coord.longitude
        } else {
            // 권한 거부/실패 → 폴백 좌표
            queryCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            errorMessage = "현재 위치를 가져오지 못했습니다. 기본 위치로 검색합니다."
        }

        await loadMore()
    }

    func loadMore() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        let lat = queryCoordinate?.latitude ?? latitude
        let lon = queryCoordinate?.longitude ?? longitude

        do {
            let pageData = try await service.searchMaps(
                latitude: lat,
                longitude: lon,
                radiusKm: radiusKm,
                zoneName: zoneName,
                zoneType: zoneType,
                page: page,
                size: size
            )

            items += pageData.content
            pageable = pageData.pageable
            page += 1
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
