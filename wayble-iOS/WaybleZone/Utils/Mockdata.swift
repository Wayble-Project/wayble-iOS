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
            "mon_thu": OpeningHours(open: "11:30", close: "22:00"),
            "fri_sat": OpeningHours(open: "12:00", close: "22:00"),
            "sun": OpeningHours(open: "12:00", close: "20:00")
        ],
        photos: [
            "mockreview1",
            "mockreview2"
        ]
    )
)


let mockReviewListResponse = ReviewListResponse(
    data: [
        Review(
            id: 101,
            userNickname: "눈송이",
            rating: 5,
            content: "너무너무 좋았어요 ~ ! 음식이 다 맛있었어요 그런데 문이 손잡이가 좀 높아서 밀기 힘들었습니다ㅠㅠ 그것만 빼면 좋아요 괜찮았어요",
            visitDate: ISO8601DateFormatter().date(from: "2024-06-21T00:00:00Z") ?? Date(),
            likes: 120,
            images: ["mockreview1"]
        ),
        Review(
            id: 102,
            userNickname: "달빛조각",
            rating: 4,
            content: "분위기 좋고 조용해서 공부하기도 좋아요. 커피도 괜찮았습니다.",
            visitDate: ISO8601DateFormatter().date(from: "2024-06-20T00:00:00Z") ?? Date(),
            likes: 95,
            images: ["mockreview2"]
        )
    ]
)

