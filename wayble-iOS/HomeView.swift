////
////  HomeView.swift
////  wayble_iOS
////
////  Created by 신민정 on 7/9/25.
////
//
//import SwiftUI
//import Foundation
//import Observation
//import AVKit
//
//
//struct HomeView: View {
//    @Bindable var WaybleviewModel = FacilitySelectionViewModel()
//    @Binding var selectedIndex: Int
//    @Environment(NavigationRouter.self) private var router
//    @Bindable var viewModel: OnboardingViewModel ///0811
//    //let zone: FavWaybleZoneInfo /// let으로 하는 게 맞나??
//    @Bindable var homeViewModel: HomeViewModel
//    @Binding var selectedDeparture: PlaceModel?
//    @Binding var selectedArrival: PlaceModel?
//    
//
//    var body: some View {
//        VStack(alignment: .leading) {
//            HStack{
//                Image(.waybleLogo3)
//                Text("wayble")
//                    .font(.mainTextSemibold20)
//            }
//            .padding(.leading,10)
//            Spacer()
//                .frame(maxHeight:21)
//            ZStack(alignment: .top) {
//                GeometryReader { geo in
//                    MP4View(filename: "Home", fileExtension: "mp4", size: geo.size)
//                        .frame(maxWidth: .infinity, maxHeight: .infinity)
//                        .clipShape(RoundedRectangle(cornerRadius: 30))
//                    
//                }
//                
//                
//                VStack(alignment: .leading,spacing: 0) {
//                    VStack(alignment: .leading, spacing: 0) {
//                    
//                    VStack(alignment: .leading,spacing: 0) {
//                        
//                        Spacer()
//                            .frame(height:19)
//                        
//                        Text("\(viewModel.userInfo.nickname)님, 안녕하세요")
//                            .font(.mainTextSemibold16)
//                        
//                        Spacer()
//                            .frame(maxHeight:9)
//                        
//                        let zoneName = homeViewModel.zone?.name ?? "아임히어"
//                        (
//                            Text("오늘은 ")
//                                .font(.mainTextSemibold24)
//                            + Text(zoneName)
//                                .font(.mainTextSemibold24)
//                                .foregroundStyle(Color("blue-700"))
//                            + Text("를 추천해요")
//                                .font(.mainTextSemibold24)
//                        )
//                        .lineLimit(2)
//                        .truncationMode(.tail)
//                        .fixedSize(horizontal: false, vertical: true)
//                        .multilineTextAlignment(.leading)
//                    }
//                    .padding(.horizontal,25)
//                    .padding(.bottom, 8)
//                    
//                    
//
//                    Spacer()
//                        .frame(height:163)
//                    
//                    HStack() { ///길찾기 버튼
//                        Button(action: {
//                            withAnimation(.default) {
//                                ///homeViewModel.zone가 없을 때 WaybleviewModel.mockZone를 FavWaybleZoneInfo 타입으로 변환해서 사용
//                                let z: FavWaybleZoneInfo = homeViewModel.zone ?? FavWaybleZoneInfo(
//                                    id: WaybleviewModel.mockZone.id,
//                                    name: WaybleviewModel.mockZone.name,
//                                    category: WaybleviewModel.mockZone.category,
//                                    imageUrl: WaybleviewModel.mockZone.imageUrl,
//                                    address: WaybleviewModel.mockZone.address,
//                                    latitude: WaybleviewModel.mockZone.latitude ?? 0.0,        // 기본값 0.0
//                                    longitude: WaybleviewModel.mockZone.longitude ?? 0.0,      // 기본값 0.0
//                                    rating: WaybleviewModel.mockZone.rating ?? 0.0,            // 기본값 0.0
//                                    reviewCount: WaybleviewModel.mockZone.reviewCount ?? 0,    // 기본값 0
//                                    facilities: WaybleviewModel.mockZone.facilities ?? []      // 기본값 []
//                                )
//
//                    // 아이콘 웨이블존 껄로 다시
//                   // let facilityItems = FacilityUtils.cardFacilityItems(from: WaybleviewModel.facilities)
//
//
//                    HStack(spacing: 32) {
//                        ForEach(facilityItems, id: \.label) { item in
//                            VStack(spacing: 5.6) {
//                                Image(item.icon)
//                                    .renderingMode(.template)
//                                    .resizable()
//                                    .frame(maxWidth: 23, maxHeight: 23)
//                                    .foregroundStyle(item.isAvailable ? Color("blue-800") : Color("gray-500"))
//
//                                Text(item.label)
//                                    .font(.mainTextSemibold9)
//                                    .lineLimit(1)
//                                    .foregroundStyle(item.isAvailable ? Color("blue-800") : Color("gray-500"))
//                            }
//                        }
//                    }
//                    .padding(.leading, 25)
//                    .padding(.top, 6)
//                    
//                    
//                }
//                
//                
//                HStack { ///길찾기 버튼
//                    Button(action: {
//                        withAnimation(.default) {
//                            // 1) 존 → 도착지 PlaceModel 변환
//                            let z: FavWaybleZoneInfo = homeViewModel.zone ?? FavWaybleZoneInfo(
//                                id: WaybleviewModel.mockZone.id,
//                                name: WaybleviewModel.mockZone.name,
//                                category: WaybleviewModel.mockZone.category,
//                                imageUrl: WaybleviewModel.mockZone.imageUrl,
//                                address: WaybleviewModel.mockZone.address,
//                                latitude: WaybleviewModel.mockZone.latitude,
//                                longitude: WaybleviewModel.mockZone.longitude,
//                                rating: WaybleviewModel.mockZone.rating,
//                                reviewCount: WaybleviewModel.mockZone.reviewCount,
//                                facilities: WaybleviewModel.mockZone.facilities
//                            )
//
//                            let arrival = PlaceModel(
//                                title: z.name,
//                                roadAddress: z.address,
//                                x: "\(z.longitude)",   // 경도
//                                y: "\(z.latitude)",    // 위도
//                                category: z.category
//                            )
//
//                            // 2) 도착지만 먼저 꽂고 길찾기 화면으로 이동
//                            self.selectedArrival = arrival
//                            SearchViewModel.shared.setPlace(arrival, for: .destination)
//                           //onAppear의 자동 현재위치 강제 세팅
//                            SearchViewModel.shared.hasUserSetDeparture = false
//                            self.selectedDeparture = nil
//                           
//                            self.selectedIndex = 15
//                            print("➡️ 길찾기 화면으로 이동. 도착지=\(arrival.title)")
//
//                        }
//                    }) {
//                        HStack(spacing: 0) {
//                            Text("길찾기")
//                                .font(.mainTextSemibold14)
//                                .foregroundStyle(Color.white)
//                                .fixedSize()
//                            Image("right")
//                        }
//                        .frame(maxWidth: 55, maxHeight: 20)
//                        .padding(.horizontal, 20)
//                        .padding(.vertical, 10)
//                        .background(Color("blue-700"))
//                        .clipShape(RoundedRectangle(cornerRadius: 20))
//                    }
//                    .buttonStyle(.plain)
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
//                .padding(.leading, 25)
//                .padding(.bottom, 24)
//                }
//                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
//            }
//            .frame(maxWidth: .infinity)
//            .aspectRatio(360.0/343.0, contentMode: .fit)
//            Spacer().frame(maxHeight:34)
//            
//            HStack(spacing: 10) {
//                Button(action: {withAnimation(.default){
//                    selectedIndex = 4
//                }
//                }) {
//                    VStack(alignment:.leading, spacing: 6) {
//                        Text("웨이블존")
//                            .font(.mainTextSemibold16)
//                        Text("우리 주변 접근성 정보를 보여드려요")
//                            .font(.mainTextRegular14)
//                            .foregroundStyle(Color.gray700)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                        
//                        Spacer()
//                        HStack {
//                            Spacer()
//                            Image("home1")
//                        }
//                    }
//                    .padding(.all, 20.0)
//                    .frame(maxWidth: .infinity)
//                    .aspectRatio(170.0/210.0, contentMode: .fit)
//                    .background(Color.white)
//                    .cornerRadius(15)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 15)
//                            .stroke(Color.gray300, lineWidth: 1)
//                    )
//                }
//                .buttonStyle(.plain)
//                
//                Button(action : {
//                    withAnimation(.default)
//                    {
//                        selectedIndex = 3 // 탭 인덱스를 이동
//                    }
//                    
//                }) {
//                    VStack(alignment:.leading, spacing: 6)  {
//                        
//                        Text("길찾기")
//                            .font(.mainTextSemibold16)
//                        Text("개인에 맞춘 최적 경로를 추천해요")
//                            .font(.mainTextRegular14)
//                            .foregroundStyle(Color.gray700)
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                        
//                        Spacer()
//                        HStack {
//                            Spacer()
//                            Image("home2")
//                        }
//                    }
//                    .padding(20)
//                    .frame(maxWidth: .infinity)
//                    .aspectRatio(170.0/210.0, contentMode: .fit)
//                    .background(Color.white)
//                    .cornerRadius(15)
//                    .overlay(
//                        RoundedRectangle(cornerRadius: 15)
//                            .stroke(Color.gray300, lineWidth: 1)
//                    )
//                }
//                .buttonStyle(.plain)
//            }
//            .frame(maxWidth: .infinity, alignment: .leading)
//            Spacer()
//        }
//        .padding(.horizontal,20)
//        .padding(.top, 12)
//        .onAppear {
//            WaybleviewModel.loadMockData()
//        }
//        
//         
//    }
//      
//}
//
//
//// MARK: - Facilities Extension
//extension Facilities {
//    func value(for option: FacilityOption) -> Bool {
//        switch option {
//        case .hasSlope: return hasSlope
//        case .hasNoDoorStep: return hasNoDoorStep
//        case .hasElevator: return hasElevator
//        case .hasTableSeat: return hasTableSeat
//        case .hasDisabledToilet: return hasDisabledToilet
//        default: return false
//        }
//    }
//}
//
//extension HomeView {
//    var facilityItems: [FacilityUtils.FacilityItem] {
//        if let z = homeViewModel.zone {
//            return FacilityUtils.cardFacilityItems(from: z.facilities)
//        } else {
//            return []
//        }
//    }
//    
//}
//











//  HomeView.swift
//  wayble_iOS
//
//  Created by 신민정 on 7/9/25.
//

import SwiftUI
import Foundation
import Observation
import AVKit


struct HomeView: View {
    @Bindable var WaybleviewModel = FacilitySelectionViewModel()
    @Binding var selectedIndex: Int
    @Environment(NavigationRouter.self) private var router
    @Bindable var viewModel: OnboardingViewModel ///0811
    //let zone: FavWaybleZoneInfo /// let으로 하는 게 맞나??
    @Bindable var homeViewModel: HomeViewModel
    @Binding var selectedDeparture: PlaceModel?
    @Binding var selectedArrival: PlaceModel?
    

    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Image(.waybleLogo3)
                Text("wayble")
                    .font(.mainTextSemibold20)
            }
            .padding(.leading,10)
            Spacer()
                .frame(maxHeight:21)
            ZStack(alignment: .top) {
                GeometryReader { geo in
                    MP4View(filename: "Home", fileExtension: "mp4", size: geo.size)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                    
                }
                
                
                VStack(alignment: .leading,spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                    
                    VStack(alignment: .leading,spacing: 0) {
                        
                        Spacer()
                            .frame(height:19)
                        
                        Text("\(viewModel.userInfo.nickname)님, 안녕하세요")
                            .font(.mainTextSemibold16)
                        
                        Spacer()
                            .frame(maxHeight:9)
                        
                        let zoneName = homeViewModel.zone?.name ?? "아임히어"
                        (
                            Text("오늘은 ")
                                .font(.mainTextSemibold24)
                            + Text(zoneName)
                                .font(.mainTextSemibold24)
                                .foregroundStyle(Color("blue-700"))
                            + Text("를 추천해요")
                                .font(.mainTextSemibold24)
                        )
                        .lineLimit(2)
                        .truncationMode(.tail)
                        .fixedSize(horizontal: false, vertical: true)
                        .multilineTextAlignment(.leading)
                    }
                    .padding(.horizontal,25)
                    .padding(.bottom, 8)
                    
                    
                    // 아이콘 웨이블존 껄로 다시
                   // let facilityItems = FacilityUtils.cardFacilityItems(from: WaybleviewModel.facilities)

                    HStack(spacing: 32) {
                        ForEach(facilityItems, id: \.label) { item in
                            VStack(spacing: 5.6) {
                                Image(item.icon)
                                    .renderingMode(.template)
                                    .resizable()
                                    .frame(maxWidth: 23, maxHeight: 23)
                                    .foregroundStyle(item.isAvailable ? Color("blue-800") : Color("gray-500"))

                                Text(item.label)
                                    .font(.mainTextSemibold9)
                                    .lineLimit(1)
                                    .foregroundStyle(item.isAvailable ? Color("blue-800") : Color("gray-500"))
                            }
                        }
                    }
                    .padding(.leading, 25)
                    .padding(.top, 6)
                    
                    
                }
                
                
                HStack { ///길찾기 버튼
                    Button(action: {
                        withAnimation(.default) {
                            // 1) 존 → 도착지 PlaceModel 변환
                            let z: FavWaybleZoneInfo = homeViewModel.zone ?? FavWaybleZoneInfo(
                                id: WaybleviewModel.mockZone.id,
                                name: WaybleviewModel.mockZone.name,
                                category: WaybleviewModel.mockZone.category,
                                imageUrl: WaybleviewModel.mockZone.imageUrl,
                                address: WaybleviewModel.mockZone.address,
                                latitude: WaybleviewModel.mockZone.latitude ?? 0.0,        // 기본값 0.0
                                   longitude: WaybleviewModel.mockZone.longitude ?? 0.0,      // 기본값 0.0
                                   rating: WaybleviewModel.mockZone.rating ?? 0.0,            // 기본값 0.0
                                   reviewCount: WaybleviewModel.mockZone.reviewCount ?? 0,    // 기본값 0
                                   facilities: WaybleviewModel.mockZone.facilities ?? .empty      // 기본값 []
                            )

                            let arrival = PlaceModel(
                                title: z.name,
                                roadAddress: z.address,
                                x: "\(z.longitude)",   // 경도
                                y: "\(z.latitude)",    // 위도
                                category: z.category
                            )

                            // 2) 도착지만 먼저 꽂고 길찾기 화면으로 이동
                            self.selectedArrival = arrival
                            SearchViewModel.shared.setPlace(arrival, for: .destination)
                           //onAppear의 자동 현재위치 강제 세팅
                            SearchViewModel.shared.hasUserSetDeparture = false
                            self.selectedDeparture = nil
                           
                            self.selectedIndex = 15
                            print("➡️ 길찾기 화면으로 이동. 도착지=\(arrival.title)")

                        }
                    }) {
                        HStack(spacing: 0) {
                            Text("길찾기")
                                .font(.mainTextSemibold14)
                                .foregroundStyle(Color.white)
                                .fixedSize()
                            Image("right")
                        }
                        .frame(maxWidth: 55, maxHeight: 20)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color("blue-700"))
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                    .buttonStyle(.plain)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                .padding(.leading, 25)
                .padding(.bottom, 24)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(360.0/343.0, contentMode: .fit)
            Spacer().frame(maxHeight:34)
            
            HStack(spacing: 10) {
                Button(action: {withAnimation(.default){
                    selectedIndex = 4
                }
                }) {
                    VStack(alignment:.leading, spacing: 6) {
                        Text("웨이블존")
                            .font(.mainTextSemibold16)
                        Text("우리 주변 접근성 정보를 보여드려요")
                            .font(.mainTextRegular14)
                            .foregroundStyle(Color.gray700)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        HStack {
                            Spacer()
                            Image("home1")
                        }
                    }
                    .padding(.all, 20.0)
                    .frame(maxWidth: .infinity)
                    .aspectRatio(170.0/210.0, contentMode: .fit)
                    .background(Color.white)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray300, lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
                
                Button(action : {
                    withAnimation(.default)
                    {
                        selectedIndex = 3 // 탭 인덱스를 이동
                    }
                    
                }) {
                    VStack(alignment:.leading, spacing: 6)  {
                        
                        Text("길찾기")
                            .font(.mainTextSemibold16)
                        Text("개인에 맞춘 최적 경로를 추천해요")
                            .font(.mainTextRegular14)
                            .foregroundStyle(Color.gray700)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                        HStack {
                            Spacer()
                            Image("home2")
                        }
                    }
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .aspectRatio(170.0/210.0, contentMode: .fit)
                    .background(Color.white)
                    .cornerRadius(15)
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color.gray300, lineWidth: 1)
                    )
                }
                .buttonStyle(.plain)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
        }
        .padding(.horizontal,20)
        .padding(.top, 12)
        .onAppear {
            WaybleviewModel.loadMockData()
        }
        
         
    }
      
}


// MARK: - Facilities Extension
extension Facilities {
    func value(for option: FacilityOption) -> Bool {
        switch option {
        case .hasSlope: return hasSlope
        case .hasNoDoorStep: return hasNoDoorStep
        case .hasElevator: return hasElevator
        case .hasTableSeat: return hasTableSeat
        case .hasDisabledToilet: return hasDisabledToilet
        default: return false
        }
    }
}

extension HomeView {
    var facilityItems: [FacilityUtils.FacilityItem] {
        if let z = homeViewModel.zone {
            return FacilityUtils.cardFacilityItems(from: z.facilities)
        } else {
            return []
        }
    }
    
}
