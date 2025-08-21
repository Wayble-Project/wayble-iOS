
//
//  MainView.swift
//  wayble_iOS
//
//  Created by 신민정 on 7/9/25.
//

import SwiftUI
///앱 실행 시 자동으로 로그인 상태를 확인하고, 해당하는 뷰로 이동하도록 MainView에 .task를 추가!!
struct MainView: View {
    @State private var place = PlaceModel()
    @State private var searchBarViewID = UUID()
    @State private var searchViewModel = SearchViewModel.shared
    @Binding var selectedIndex: Int
    @State private var transportationVM = TransportationViewModel()
    @State private var selectedRoute: RouteOption? = nil
    @Binding var step: Int
    @State private var router = NavigationRouter()
    @State var signupViewModel = SignupViewModel()
    @State var onboardingViewModel = OnboardingViewModel()
    @State var homeViewModel = HomeViewModel()
    @State private var selectedDeparture: PlaceModel? = nil
    @State private var selectedArrival: PlaceModel? = nil



    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack(path: $router.path) {
                ZStack {
                    
                    switch selectedIndex {
                        // 밑에 추가하고 싶은 뷰 적기
                    case 0: HomeView(selectedIndex: $selectedIndex, viewModel: onboardingViewModel, homeViewModel: homeViewModel, selectedDeparture: $selectedDeparture,
                                     selectedArrival: $selectedArrival)
                           
                    case 1: MapView()
                    case 2: ProfileView(selectedIndex: $selectedIndex)
                    case 3: SearchHomeView(selectedIndex: $selectedIndex)
                    case 4: WaybleZoneMainView(vm: TopPlaceViewModel(),selectedIndex: $selectedIndex)
                    case 5:
                        
                        SearchBarView(
                            viewModel: searchViewModel,
                            place: $place,
                            selectedIndex: $selectedIndex,
                            onSelectDeparture: { place in
                                selectedDeparture = place
                            },
                            onSelectDestination: { place in
                                selectedArrival = place
                            }
                        )
                    case 6:
                        OnlyMapView(
                            place: $place,
                            selectedIndex: $selectedIndex,
                            selectedDeparture: $selectedDeparture,
                            selectedArrival: $selectedArrival,
                            searchBarViewID: $searchBarViewID
                        )
                    case 7: LoginView(selectedIndex: $selectedIndex, onboardingViewModel: onboardingViewModel, homeViewModel: homeViewModel)
                    case 8: SignupEmailView(viewModel: signupViewModel, selectedIndex: $selectedIndex) //동일한 뷰모델 -> 유저 정보 저장
                    case 9: SignupPasswordView(viewModel: signupViewModel, selectedIndex: $selectedIndex)
                    case 10: SignupCompletedView(viewModel: signupViewModel, selectedIndex: $selectedIndex)
                    case 11: SplashView(selectedIndex: $selectedIndex, onboardingViewModel: onboardingViewModel, homeViewModel: homeViewModel)
                    case 12: OnboardingCompletedView(viewModel: onboardingViewModel, homeViewModel: homeViewModel, selectedIndex: $selectedIndex)
                    case 13: OnboardingRootView(viewModel: onboardingViewModel, selectedIndex: $selectedIndex)
                    case 14: SignupTermsView(selectedIndex: $selectedIndex)

                    case 15:
                        Transportation(
                            selectedIndex: $selectedIndex,
                            entryType: .destination,
                            selectedArrival: $selectedArrival,
                            selectedDeparture: $selectedDeparture,
                            viewModel: transportationVM,
                            searchViewModel: $searchViewModel,
                            transportation: SearchViewModel.shared.transportation
                        )
                        .id(UUID())
                                                  
                    case 16:
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
                    case 17:
                        MapDetailView(
                            place: place,
                            selectedIndex: $selectedIndex,
                            searchBarViewID: $searchBarViewID,
                            selectedDeparture: $selectedDeparture,
                            selectedArrival: $selectedArrival
                        )
                        
                    case 18: MainMapView(selectedIndex: $selectedIndex)

                    case 19: SavedPlaceListView(vm: UserPlaceViewModel(), selectedIndex: $selectedIndex)
                    case 20: WaybleZoneSearchView(selectedIndex: $selectedIndex)

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
                        HomeView(selectedIndex: $selectedIndex, viewModel: onboardingViewModel, homeViewModel: homeViewModel,  selectedDeparture: $selectedDeparture,
                                 selectedArrival: $selectedArrival)
                            .navigationBarBackButtonHidden(true)
                    case .signupEmail:
                        SignupEmailView(viewModel: signupViewModel, selectedIndex: $selectedIndex)
                            .navigationBarBackButtonHidden(true)
                    case .findPassword:
                        findPasswordView()
                            .navigationBarBackButtonHidden(true)
                    case .login:
                        LoginView(selectedIndex: $selectedIndex, onboardingViewModel: onboardingViewModel, homeViewModel: homeViewModel)
                            .navigationBarBackButtonHidden(true)
                    case .wayblezone:
                        WaybleZoneMainView(vm: TopPlaceViewModel(),selectedIndex: $selectedIndex)
                            .navigationBarBackButtonHidden(true)
                        
                    case .waybleZoneSearch:
                        WaybleZoneSearchView(selectedIndex: $selectedIndex)
                            .navigationBarBackButtonHidden(true)
                  
                    case .placeDetailView(let id):
                        PlaceDetailView(vm: PlaceDetailViewModel(zoneID: id),selectedIndex: $selectedIndex)
                            .navigationBarBackButtonHidden(true)
                    
                    case .writeReview(let place):
                        WriteReView(viewModel: FacilitySelectionViewModel(),selectedIndex: $selectedIndex ,place: place)
                            .navigationBarBackButtonHidden(true)
                        
                    case .addListView:
                        AddListView(selectedIndex: $selectedIndex,userPlaceVM: UserPlaceViewModel())
                            .navigationBarBackButtonHidden(true)
                        
                    case .wzMainMapView:
                        WZMainMapView(selectedIndex: $selectedIndex)
                            .navigationBarBackButtonHidden(true)
                        
                    case .savedPlaceListView:
                         SavedPlaceListView(vm: UserPlaceViewModel(),selectedIndex: $selectedIndex)
                            .navigationBarBackButtonHidden(true)
                        
                    case .signupCompleted:
                        SignupCompletedView(viewModel: signupViewModel, selectedIndex: $selectedIndex)
                            .navigationBarBackButtonHidden(true)
                    case .routeDetail(let route):
                        let routeOption = RouteOption(
                            totalTime: route.totalTime,
                            arrivalTime: route.arrivalTime,
                            cost: route.cost,
                            steps: route.steps
                        )
                        RouteDetail(route: routeOption)
                            .navigationBarBackButtonHidden(true)
                            
                    case .searchBar:
                        SearchBarView(
                            viewModel: searchViewModel,
                            place: $place,
                            selectedIndex: $selectedIndex,
                            onSelectDeparture: { place in
                                selectedDeparture = place
                            },
                            onSelectDestination: { place in
                                selectedArrival = place
                            }
                        )
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
                            viewModel: transportationVM,  
                            searchViewModel: $searchViewModel,
                            transportation: SearchViewModel.shared.transportation
                        )
                        .navigationBarBackButtonHidden(true)
                    case .splashView:
                        SplashView(selectedIndex: $selectedIndex, onboardingViewModel: onboardingViewModel, homeViewModel: homeViewModel)
                            .navigationBarBackButtonHidden(true)
                    case .onboardingCompleted:
                        OnboardingCompletedView(viewModel: onboardingViewModel, homeViewModel: homeViewModel, selectedIndex: $selectedIndex)
                            .navigationBarBackButtonHidden(true)
                    case .onboardingRoot:
                        OnboardingRootView(viewModel: onboardingViewModel, selectedIndex: $selectedIndex)
                            .navigationBarBackButtonHidden(true)
                    case .signupTerm:
                        SignupTermsView(selectedIndex: $selectedIndex)
                            .navigationBarBackButtonHidden(true)
                    case .mainMapView:
                        MainMapView(selectedIndex: $selectedIndex)
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
        case 5,6,7,8,9,10,11,12,13,14,15,16,17,19:
            return true
        default:
            return false
        }
    }}



