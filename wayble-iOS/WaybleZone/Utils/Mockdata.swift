import Foundation

let mockWaybleZoneResponse = WaybleZoneResponse(
    data: WaybleZone(
        id: 1,
        name: "아임히어",
        category: "카페",
        address: "서울 용산구 백범로 326 1층",
        rating: 4.5,
        reviewCount: 128,
        contactNumber: "010-9736-6282",
        imageUrl: "cafeMockImage",
        facilities: Facilities(
            hasSlope: true,
            hasNoDoorStep: false,
            hasElevator: true,
            hasTableSeat: true,
            hasDisabledToilet: true,
            floorInfo: "1층"
        ),
        businessHours: [
            "monday": OpeningHours(open: "11:30", close: "22:00"),
            "tuesday": OpeningHours(open: "10:30", close: "22:00"),
            "friday": OpeningHours(open: "12:00", close: "22:00"),
            "sunday": OpeningHours(open: "12:00", close: "20:00")
        ],
        photos: [
            "mockreview1",
            "mockreview2"
        ]
    )
)

let mockSavedPlaces: [SavedPlace] = [
    SavedPlace(placeID: 1, title: "학교 근처 카페", color: "Red", waybleZone: [mockWaybleZoneResponse.data, mockWaybleZoneResponse.data]),
    SavedPlace(placeID: 2, title: "카공 카페", color: "Yellow", waybleZone: [mockWaybleZoneResponse.data]),
    SavedPlace(placeID: 3, title: "남남",color: "Green", waybleZone: [mockWaybleZoneResponse.data])
]


let mockReviewListResponse = ReviewListResponse(
    data: [
        Review(
            id: 101,
            userNickname: "눈송이",
            rating: 5,
            content: "너무너무 좋았어요 ~ ! 음식이 다 맛있었어요 그런데 문이 손잡이가 좀 높아서 밀기 힘들었습니다ㅠㅠ 그것만 빼면 좋아요 괜찮았어요",
            visitDate: "2025-06-30",
            likes: 120,
            images: ["mockreview1"]
        ),
        Review(
            id: 102,
            userNickname: "달빛조각",
            rating: 4,
            content: "분위기 좋고 조용해서 공부하기도 좋아요. 커피도 괜찮았습니다.",
            //visitDate: ISO8601DateFormatter().date(from: "2024-06-20T00:00:00Z") ?? Date(),
            visitDate: "2025-06-30",
            likes: 95,
            images: ["mockreview2"]
        )
    ]
)

let mockFavoritesZones: [FavoritesWaybleZone] = [
    FavoritesWaybleZone(
        waybleZoneInfo: FavWaybleZoneInfo(
            id: 1,
            name: "아임히어",
            category: "카페",
            imageUrl: "cafeMockImage",
            address: "서울 용산구 백범로 326 1층",
            latitude: 37.5442,
            longitude: 127.0563,
            rating: 4.5,
            reviewCount: 128,
            facilities: Facilities(
                hasSlope: true,
                hasNoDoorStep: true,
                hasElevator: false,
                hasTableSeat: true,
                hasDisabledToilet: false,
                floorInfo: "1층"
            )
        )
    ),
    FavoritesWaybleZone(
        waybleZoneInfo: FavWaybleZoneInfo(
            id: 2,
            name: "투썸플레이스 효창점",
            category: "음식점",
            imageUrl: "cafeMockImage",
            address: "서울 강남구 테헤란로 212",
            latitude: 37.4981,
            longitude: 127.0276,
            rating: 4.3,
            reviewCount: 98,
            facilities: Facilities(
                hasSlope: true,
                hasNoDoorStep: false,
                hasElevator: true,
                hasTableSeat: true,
                hasDisabledToilet: true,
                floorInfo: "2층"
            )
        )
    ),
    FavoritesWaybleZone(
        waybleZoneInfo: FavWaybleZoneInfo(
            id: 3,
            name: "이디야커피 효창점",
            category: "카페",
            imageUrl: "cafeMockImage",
            address: "서울 마포구 연남동 227-15",
            latitude: 37.5648,
            longitude: 126.9221,
            rating: 4.0,
            reviewCount: 76,
            facilities: Facilities(
                hasSlope: false,
                hasNoDoorStep: true,
                hasElevator: false,
                hasTableSeat: true,
                hasDisabledToilet: false,
                floorInfo: "지상 1층"
            )
        )
    )
]
