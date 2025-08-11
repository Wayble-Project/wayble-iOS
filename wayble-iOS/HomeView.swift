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
    @State private var selectedArrival: PlaceModel? = nil
    @State private var selectedDeparture: PlaceModel? = nil
    @Binding var selectedIndex: Int
    @Environment(NavigationRouter.self) private var router
    @Bindable var viewModel: OnboardingViewModel ///0811
#if DEBUG
    @EnvironmentObject var authViewModel: AuthViewModel
#endif
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Image(.waybleLogo3)
                Text("wayble")
                    .font(.mainTextSemibold20)
            }
            .padding(.leading,10)
            Spacer()
                .frame(height:21)
            ZStack(alignment: .top) {
                GeometryReader { geo in
                    MP4View(filename: "Home", fileExtension: "mp4", size: geo.size)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                    
                }
                .frame(width: 360, height: 343)
                
                VStack(alignment: .leading,spacing: 0) {
                    
                    VStack(alignment: .leading,spacing: 0) {
                        VStack(alignment: .leading,spacing: 0) {
                            
                            Spacer()
                                .frame(height:19)
                            
                            Text("\(viewModel.userInfo.nickname)님, 안녕하세요")
                                .font(.mainTextSemibold16)
                            
                            Spacer()
                                .frame(height:9)
                            
                            (
                                Text("오늘은 ")
                                    .font(.mainTextSemibold24) +
                                Text("아임히어") //여기 웨이블존 모델 카페 이름으로 다시
                                    .font(.mainTextSemibold24)
                                    .foregroundStyle(Color("blue-700")) +
                                Text("를 추천해요")
                                    .font(.mainTextSemibold24)
                            )
                        }
                        .padding(.horizontal,25)
                        
                        
                        Spacer()
                            .frame(height:6)
                        
                        // 아이콘 웨이블존 껄로 다시
                        let facilityItems = FacilityUtils.cardFacilityItems(from: WaybleviewModel.facilities)

                        HStack(spacing: 32) {
                            ForEach(facilityItems, id: \.label) { item in
                                VStack(spacing: 5.6) {
                                    Image(item.icon)
                                        .renderingMode(.template)
                                        .resizable()
                                        .frame(width: 23, height: 23)
                                        .foregroundStyle(item.isAvailable ? Color("blue-800") : Color("gray-500"))

                                    Text(item.label)
                                        .font(.mainTextSemibold9)
                                        .lineLimit(1)
                                        .foregroundStyle(item.isAvailable ? Color("blue-800") : Color("gray-500"))
                                }
                            }
                        }
                        .padding(.leading, 25)
                        
                        
                    }
                    
                    
                    Spacer()
                        .frame(height:163)
                    
                    HStack() {
                        Button(action: {
                            withAnimation(.default) {
                                let zone = WaybleviewModel.mockZone

                                let arrival = PlaceModel(
                                    title: selectedDeparture?.title ?? zone.name,
                                    roadAddress: zone.address,
                                    x: "\(zone.longitude)",
                                    y: "\(zone.latitude)",
                                    category: zone.category
                                )

                                LocationManager.shared.requestLocation { coordinate in
                                    guard let coordinate = coordinate else { return }

                                    Task {
                                        do {
                                            let (title, roadAddress) = try await SearchViewModel.shared.callReverseGeocodeAPI(
                                                lat: coordinate.latitude,
                                                lng: coordinate.longitude
                                            )

                                            let departure = PlaceModel(
                                                title: title,
                                                roadAddress: roadAddress,
                                                x: "\(coordinate.longitude)",
                                                y: "\(coordinate.latitude)",
                                                category: "기타"
                                            )

                                            router.push(
                                                .transportation(
                                                    entryType: .destination,
                                                    selectedArrival: arrival,
                                                    selectedDeparture: departure
                                                )
                                            )
                                        } catch {
                                            print("❌ 역지오코딩 실패: \(error)")
                                        }
                                    }
                                }
                            }
                        }) {
                            HStack(spacing: 0) {
                                Text("길찾기")
                                    .font(.mainTextSemibold14)
                                    .foregroundStyle(Color.white)
                                    .fixedSize()
                                
                                Image("right")
                            }
                            .frame(width: 55, height: 20)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color("blue-700"))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.leading, 20)
                    
                    Spacer()
                        .frame(height: 45)

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
                            .frame(width: 170, height: 210)
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
                            .frame(width: 170, height: 210)
                            .background(Color.white)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.gray300, lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer()
                }
            }
            .padding(.horizontal,5)
        }
        .padding(.horizontal,20)
        .padding(.top, 12)
        .onAppear {
            WaybleviewModel.loadMockData()
        }
        .task {
            await viewModel.fetchNicknameIfNeeded()
        }
#if DEBUG
.overlay(alignment: .bottomTrailing) {
    Button("로그아웃(키체인 삭제)") {
        KeychainManager.standard.deleteSession(for: "tokenInfoKey")
        authViewModel.state = .loggedOut
    }
    .padding(.horizontal, 12)
    .padding(.vertical, 8)
    .background(.ultraThinMaterial)
    .clipShape(Capsule())
    .shadow(radius: 3)
    .padding(.trailing, 16)
    .padding(.bottom, 100)   // ← 탭바보다 위로 올림. 필요하면 숫자 조절
    .zIndex(999)
}
#endif
    }
      
}
/*
#Preview {
    HomeView(selectedIndex: .constant(0), viewModel: $viewModel)
        .withRouter(selectedIndex: .constant(0),router: NavigationRouter())
}
 */

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
