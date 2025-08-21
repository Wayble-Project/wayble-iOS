//
//  MainMapView.swift
//  wayble-iOS
//
//  Created by 이서현 on 8/11/25.
//

import SwiftUI
import NMapsMap

struct MainMapView: View {
    
    // MARK: - Map dependencies (ported from OnlyMapView)
    @State private var mapCenter: NMGLatLng = NMGLatLng(lat: 37.5386, lng: 126.9628)
    @StateObject private var viewModel = MainMapViewModel()
    @Binding var selectedIndex: Int
    @Environment(NavigationRouter.self) private var router
    
    var body: some View {
        VStack(spacing: 0) {
            MainTopBar(selectedIndex: $selectedIndex) { kind in
                Task {
                    await viewModel.loadFacilities(
                        lat: centerLat,
                        lng: centerLng,
                        facilityType: kind.apiParam
                    )
                }
            }
            
            //MARK: - 지도 뷰
            ZStack() {
                NaverMapView(
                    centerX: centerLng,
                    centerY: centerLat,
                    onLocationChanged: { newLat, newLng in
                        mapCenter = NMGLatLng(lat: newLat, lng: newLng)
                    },
                    zoomLevel: 16,
                    showMarker: false,
                    facilities: viewModel.homeFacilities
                )
                /*
                Image("pin11")
                    .frame(width: 46, height: 58.78)
                 */
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(.container, edges: .bottom)
            
        } //v
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .appToast($viewModel.errorMessage) ///0815 ToastUI
        ///MainMapViewModel.errorMessage에 문자열이 들어가면, 화면 하단에 토스트가 뜨고 자동으로 사라지면서 errorMessage도 알아서 nil로 정리
    }
    
    
    
    // MARK: - Computed center coordinates for NaverMapView
    private var centerLat: Double { mapCenter.lat }
    private var centerLng: Double { mapCenter.lng }
}


//MARK: - 상단 바

struct MainTopBar: View {
    @Binding var selectedIndex: Int
    var onSelect: (Convenient) -> Void = { _ in }
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                SearchBar()
                Spacer()
                NavigationLink {
                    SavedPlaceListView(vm: UserPlaceViewModel(), selectedIndex: $selectedIndex)
                } label: {
                    HeartButton()
                }
            } //h
            .padding(.bottom, 14)
            .padding(.trailing, 20)
            TopConvenientBar(onSelect: onSelect)
                .padding(.bottom, 21)
        }
        .padding(.leading, 20)
    }
    
}

#Preview {
    NavigationStack {
        MainMapView(selectedIndex: .constant(0))
            .environment(NavigationRouter())
    }
}

