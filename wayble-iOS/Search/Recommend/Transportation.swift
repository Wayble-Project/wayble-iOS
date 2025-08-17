//
//  Transportation.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/13/25.
//

import Foundation
import SwiftUI
import CoreLocation

enum EntryType: String, Hashable {
    case departure
    case destination
}

struct Transportation: View {
    @Binding var selectedIndex: Int
    @State private var searchBarViewID = UUID()
    @Environment(NavigationRouter.self) private var router
    @State private var showDetail: Bool = false
    @State private var didAutoLoadTransit: Bool = false
    @State private var selectedRoute: RouteOption? = nil
    var entryType: EntryType
    @Binding var selectedArrival: PlaceModel?
    @Binding var selectedDeparture: PlaceModel?
    var onBack: (() -> Void)? = nil
    
    var viewModel: TransportationViewModel
    @Binding var searchViewModel: SearchViewModel
    var transportation: TransportationModel
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 파란 헤더 (출발/도착/엑스버튼)
            VStack(spacing: 0) {
                HStack(alignment: .top) {
                    Button(action: {
                        // 1) 바인딩된 PlaceModel도 스왑 (UI와 데이터 일치)
                        let tmp = selectedDeparture
                        selectedDeparture = selectedArrival
                        selectedArrival = tmp

                        // 2) ViewModel의 텍스트 필드 값(문자열)도 스왑해 동기화
                        viewModel.swapLocations()

                        // 3) 출발/도착 PlaceModel이 있으면 도보 경로 API 재요청
                        // 이제 여기에 대중교통api 도 추가하기
                        if let dep = selectedDeparture, let arr = selectedArrival {
                            Task {
                                await viewModel.fetchWalkingRoute(departure: dep, arrival: arr)
                                // 대중교통도 탭이 Transit이면 함께 새로고침
                                if viewModel.transportation.selectedTab == .transit {
                                    await viewModel.fetchTransitFirst(departure: dep, arrival: arr)
                                }
                            }
                        }
                    }) {
                        Image("switch")
                            .resizable()
                            .frame(width: 26, height: 26)
                    }
                    .padding(.top, 8)
                    .offset(y: 30)
                    
                    Spacer()
                        .frame(width: 5)
                    
                    VStack(spacing: 0) {
                        Button(action: {
                            searchViewModel.entryType = .departure  // ✅ 출발지 클릭
                            searchBarViewID = UUID()
                            selectedIndex = 5
                        })  {
                            HStack(alignment: .center) {
                                Text(selectedDeparture?.title.htmlStripped ?? "출발지 없음")
                                    .foregroundStyle(Color("darkblue-500"))
                                    .font(.mainTextSemibold14)
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 20)
                        .frame(width: 269, height: 51)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .inset(by: 0.5)
                                .stroke(Color.gray200, lineWidth: 1)
                        )
                        
                        Button(action: {
                            searchViewModel.entryType = .destination  //  도착지 클릭
                            searchBarViewID = UUID()
                            selectedIndex = 5
                        }) {
                            HStack() {
                                Text(selectedArrival?.title.htmlStripped ?? "")
                                    .foregroundStyle(Color("darkblue-500"))
                                    .font(.mainTextSemibold14)
                                Spacer()
                            }
                        }
                        .padding(.horizontal, 20)
                        .frame(width: 269, height: 51)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .inset(by: 0.5)
                                .stroke(Color.gray200, lineWidth: 1)
                        )
                        .padding(.bottom, 10)
                    }
                    
                    Spacer()
                        .frame(width: 15)
                    
                    Button(action: {
                        //엑스버튼액션넣기
                    }) {
                        Image("xButton")
                            .resizable()
                            .frame(width: 26, height: 26)
                    }
                    .padding(.top, 8)
                    .offset(y: 5)
                }
                .padding(.vertical, 12)
            }
            .frame(maxWidth: .infinity)
            .background(Color("blue-50"))
            
            // 탭 바 (대중교통 | 도보)
            VStack(spacing: 0) {
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    ForEach(TransportationTab.allCases.indices, id: \.self) { index in
                        let tab = TransportationTab.allCases[index]
                        Button(action: {
                            viewModel.setTab(to: tab)
                        }) {
                            VStack(spacing:0) {
                                Spacer()
                                    .frame(height:11)
                                Text(tab.rawValue)
                                    .font(.mainTextSemibold14)
                                    .foregroundColor(viewModel.transportation.selectedTab == tab ? .black : .gray300)
                                    .lineLimit(1)
                                    .fixedSize()
                                    .frame(height: 22)
                                Spacer()
                                    .frame(height:11)
                                Rectangle()
                                    .frame(width: 130, height: 2)
                                    .foregroundColor(viewModel.transportation.selectedTab == tab ? .black : .clear)
                            }
                            .frame(maxWidth: .infinity)
                        }
                        
                        if index < TransportationTab.allCases.count - 1 {
                            Rectangle()
                                .fill(Color.gray300)
                                .frame(width: 1, height: 14)
                        }
                    }
                }
                .padding(.horizontal)
                .background(Color.white)
                
                Rectangle()
                    .fill(Color.gray300)
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
            }
            
            // 아래 영역: 도착지 없으면 검색 히스토리, 있으면 기존 화면
            if selectedArrival == nil, selectedDeparture != nil {
                //  출발만 있는 상태 → 탭바 바로 아래에 전체 높이 플레이스홀더 노출
                NoSearchView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            } else if showDetail {
                if let route = selectedRoute {
                    RouteDetail(onBack: { showDetail = false }, route: route)
                }
            } else {
                if viewModel.transportation.selectedTab == .walking {
                    if let start = selectedDeparture, let end = selectedArrival,
                       let startX = Double(start.x ?? ""), let startY = Double(start.y ?? ""),
                       let endX = Double(end.x ?? ""), let endY = Double(end.y ?? "") {

                        let distance = CLLocation(latitude: startY, longitude: startX)
                            .distance(from: CLLocation(latitude: endY, longitude: endX))

                        if distance > 30000 {
                            longView()
                        } else {
                            WalkingView(
                                viewModel: viewModel.walkViewModel,
                                selectedDeparture: $selectedDeparture,
                                selectedArrival: $selectedArrival
                            )
                        }
                    } else {
                        WalkingView(
                            viewModel: viewModel.walkViewModel,
                            selectedDeparture: $selectedDeparture,
                            selectedArrival: $selectedArrival
                        )
                    }
                } else {
                    // 🔹 대중교통 탭 본문: 에러/로딩/리스트
                    VStack(spacing: 0) {
                        // 에러 배너
                        if let err = viewModel.transitError {
                            Text(err)
                                .font(.footnote)
                                .foregroundStyle(.red)
                                .padding(10)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.red.opacity(0.08))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .padding(.horizontal, 16)
                                .padding(.top, 8)
                        }

                        // 경로 카드 리스트
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.transportation.recommendedRoutes.indices, id: \.self) { index in
                                    let route = viewModel.transportation.recommendedRoutes[index]
                                    
                                    RouteView(
                                        route: route,
                                        onRouteSelected: {
                                            selectedRoute = route
                                            showDetail = true
                                        }
                                    )
                                    .onAppear {
                                        guard
                                            index == viewModel.transportation.recommendedRoutes.count - 1,
                                            viewModel.transitHasNext,
                                            !viewModel.isTransitLoading,
                                            let dep = selectedDeparture,
                                            let arr = selectedArrival
                                        else { return }
                                        Task { await viewModel.fetchTransitNext(departure: dep, arrival: arr) }
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 8)
                        }
                        // 로딩 오버레이(상단)
                        .overlay(alignment: .top) {
                            if viewModel.isTransitLoading {
                                ProgressView()
                                    .padding(10)
                                    .background(.ultraThinMaterial)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                    .padding(.top, 8)
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: viewModel.transportation.selectedTab) { newTab in
            guard newTab == .transit else { return }
            // 출발/도착이 모두 있고 아직 불러오지 않았다면 첫 페이지 요청
            if let dep = selectedDeparture, let arr = selectedArrival,
               !viewModel.isTransitLoading,
               viewModel.transportation.recommendedRoutes.isEmpty {
                Task {
                    await viewModel.fetchTransitFirst(departure: dep, arrival: arr)
                }
            }
        }
        .onAppear {
            print("[Transportation.onAppear] dep=\(String(describing: selectedDeparture?.title)) / hasUserSetDeparture=\(searchViewModel.hasUserSetDeparture)")
            if selectedDeparture == nil && !searchViewModel.hasUserSetDeparture {
                LocationManager.shared.requestLocation { coordinate in
                    guard let coordinate = coordinate else { return }
                    Task {
                        do {
                            let (title, road) = try await searchViewModel.callReverseGeocodeAPI(
                                lat: coordinate.latitude, lng: coordinate.longitude
                            )
                            // 대기 중에 값이 세팅됐을 수도 있으니 한 번 더 체크
                            if selectedDeparture != nil { return }
                            selectedDeparture = PlaceModel(
                                title: title,
                                roadAddress: road,
                                x: String(coordinate.longitude),
                                y: String(coordinate.latitude)
                            )
                            // 자동 세팅이 한 번만 일어나도록 플래그 갱신
                            searchViewModel.hasUserSetDeparture = true
                            print("현재 위치 기반 출발지 설정 완료: \(title)")
                        } catch {
                            print("역지오코딩 실패: \(error.localizedDescription)")
                        }
                    }
                }
            }
            // 화면 진입 시 기본 탭이 대중교통이라면 1회 자동 로드
            if viewModel.transportation.selectedTab == .transit,
               !didAutoLoadTransit,
               let dep = selectedDeparture,
               let arr = selectedArrival,
               viewModel.transportation.recommendedRoutes.isEmpty {
                didAutoLoadTransit = true
                Task {
                    await viewModel.fetchTransitFirst(departure: dep, arrival: arr)
                }
            }
        }
        .onChange(of: selectedArrival) { newValue in
            guard let dep = selectedDeparture, let arr = newValue else { return }
            Task {
                await viewModel.fetchWalkingRoute(departure: dep, arrival: arr)
                // 도착지가 바뀌면, 현재 탭이 대중교통일 때 즉시 새로고침
                if viewModel.transportation.selectedTab == .transit {
                    await viewModel.fetchTransitFirst(departure: dep, arrival: arr)
                }
            }
        }
    }
}

#Preview {
    Transportation(
        selectedIndex: .constant(0),
        entryType: .departure,
        selectedArrival: .constant(nil),
        selectedDeparture: .constant(nil),
        viewModel: TransportationViewModel(),
        searchViewModel: .constant(SearchViewModel.shared),
        transportation: SearchViewModel.shared.transportation
    )
    .environment(NavigationRouter())
}
