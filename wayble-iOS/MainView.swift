//
//  MainView.swift
//  wayble_iOS
//
//  Created by 신민정 on 7/9/25.
//

import SwiftUI

struct MainView: View {
    @State private var place = PlaceModel()
    @State private var searchViewModel = SearchViewModel()
    @State private var searchBarViewID = UUID()
    @Binding var selectedIndex: Int
    @State private var router = NavigationRouter()
    @State private var selectedDeparture: PlaceModel? = nil
    @State private var selectedArrival: PlaceModel? = nil


    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack(path: $router.path) {
                ZStack {
                    
                    switch selectedIndex {
                        // 밑에 추가하고 싶은 뷰 적기
                    case 0: HomeView(selectedIndex: $selectedIndex)
                    case 1: MapView()
                    case 2: ProfileView()
                    case 3: SearchHomeView(selectedIndex: $selectedIndex)
                    case 4: WaybleZoneMainView()
                    case 5:
                        SearchBarView(viewModel: searchViewModel, place: $place, selectedIndex: $selectedIndex, entryPoint: .directions)
                            .id(searchBarViewID)
                    case 6:
                        OnlyMapView(
                            place: $place,
                            selectedIndex: $selectedIndex,
                            searchBarViewID: $searchBarViewID
                        )
                    case 7:
                        Transportation(
                            selectedIndex: $selectedIndex,
                            entryType: .destination,
                            selectedArrival: $selectedArrival,
                            selectedDeparture: $selectedDeparture,
                            viewModel: TransportationViewModel(),
                            searchViewModel: .constant(SearchViewModel.shared),
                            transportation: SearchViewModel.shared.transportation
                        )
                        .id(UUID())
                                                
                       
                    case 8:
                        VStack {
                           
                            MapDetailView(
                                place: searchViewModel.selectedPlace,
                                selectedIndex: $selectedIndex,
                                searchBarViewID: $searchBarViewID,
                                selectedDeparture: $selectedDeparture,
                                selectedArrival: $selectedArrival
                            )
                            .onAppear {
                                print("MapDetailView - 전달된 place: \(searchViewModel.selectedPlace.title), x: \(searchViewModel.selectedPlace.x ?? "nil"), y: \(searchViewModel.selectedPlace.y ?? "nil")")
                            }
                        }
                       
                        .id(searchViewModel.selectedPlace.id)
                    default:
                        Text("오류!")
                    }
                    
                }
                .onChange(of: searchViewModel.selectedPlace) {
                    print("selectedPlace 변경됨: \(searchViewModel.selectedPlace.title), id: \(searchViewModel.selectedPlace.id)")
                }
                .onAppear {
                    print("MainView 다시 진입됨")
                }
                
                //모든 뷰에서 탭이 보이도록 설정
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .searchHome:
                        SearchHomeView(selectedIndex: $selectedIndex)
                            .navigationBarBackButtonHidden(true)
                    case .home:
                        HomeView(selectedIndex: $selectedIndex)
                            .navigationBarBackButtonHidden(true)
                    case .signup:
                        SignupEmailView()
                            .navigationBarBackButtonHidden(true)
                    case .findPassword:
                        findPasswordView()
                            .navigationBarBackButtonHidden(true)
                    case .login:
                        LoginView()
                            .navigationBarBackButtonHidden(true)
                    case .wayblezone:
                        WaybleZoneMainView()
                            .navigationBarBackButtonHidden(true)
                    case .onboardingCompleted:
                        OnboardingCompletedView()
                            .navigationBarBackButtonHidden(true)
                    case .routeDetail:
                        RouteDetail()
                            .navigationBarBackButtonHidden(true)
                    case .searchBar:
                        SearchBarView(viewModel: searchViewModel, place: .constant(PlaceModel()), selectedIndex: $selectedIndex, entryPoint: .directions)
                            .navigationBarBackButtonHidden(true)
                    case .OnlyMapView:
                        SearchHomeView(selectedIndex: $selectedIndex)
                            .navigationBarBackButtonHidden(true)
                        
                    case .mapDetail:
                        MapDetailView(
                            place: searchViewModel.selectedPlace,
                            selectedIndex: $selectedIndex,
                            searchBarViewID: $searchBarViewID,
                            selectedDeparture: $selectedDeparture,
                            selectedArrival: $selectedArrival
                        )
                        .navigationBarBackButtonHidden(true)
                    case .transportation(let entryType, let arrival, let departure):
                        Transportation(
                            selectedIndex: $selectedIndex,
                            entryType: entryType,
                            selectedArrival: Binding(get: { arrival }, set: { selectedArrival = $0 }),
                            selectedDeparture: Binding(get: { departure }, set: { selectedDeparture = $0 }),
                            viewModel: TransportationViewModel(),
                            searchViewModel: .constant(SearchViewModel.shared),
                            transportation: SearchViewModel.shared.transportation
                        )
                        .navigationBarBackButtonHidden(true)
                    
                    }
                }
            }
            .id(selectedIndex)

            
                if !shouldHideTabBar {
                    CustomTabBarView(selectedIndex: $selectedIndex)
                        .offset(y:20)
                     
            }
        }
        .environment(router)
    }
    // 커스텀 바 안보이게 설정 !!
    // 안 보이고 싶은곳 selectedIndex 따라서 추가하기
    var shouldHideTabBar: Bool {
        switch selectedIndex {
        case 5:
            return true
        case 6:
            return true
        case 7:
            return true
        case 8:
            return true
        default:
            return false
        }
    }}
