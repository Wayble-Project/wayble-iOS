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
        ],
        
        latitude :37.536577523624985,
        longitude :126.96403125739117
    )
)

let mockSavedPlaces: [SavedPlace] = [
    SavedPlace(placeID: 1, title: "학교 근처 카페", color: "Red", waybleZone: mockWaybleZoneResponse.data),
    SavedPlace(placeID: 2, title: "카공 카페", color: "Yellow", waybleZone: mockWaybleZoneResponse.data),
    SavedPlace(placeID: 3, title: "남남",color: "Green", waybleZone: mockWaybleZoneResponse.data)
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

