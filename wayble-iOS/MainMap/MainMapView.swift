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
    @State private var mapCenter: NMGLatLng = NMGLatLng(lat: 37.5665, lng: 126.9780)
    @State private var viewModel = SearchViewModel()
    
    @Environment(NavigationRouter.self) private var router
    
    var body: some View {
        VStack(spacing: 0) {
            MainTopBar()
            
            //MARK: - 지도 뷰
            ZStack() {
                NaverMapView(
                    centerX: centerLng, /// 지도 중심 경도 값
                    centerY: centerLat, /// 지도 중심 위도 값
                    ///onLocationChanged; 지도 중심이 바뀔 때 호출되는 콜백
                    onLocationChanged: { newLat, newLng in
                        mapCenter = NMGLatLng(lat: newLat, lng: newLng) /// 상태값 갱신
                        viewModel.handleCenterChanged(lat: newLat, lng: newLng) ///뷰모델에 알림
                    },
                    zoomLevel: 16,
                    showMarker: false
                    
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
    }
    
    
    
    // MARK: - Computed center coordinates for NaverMapView
    private var centerLat: Double { mapCenter.lat }
    private var centerLng: Double { mapCenter.lng }
}


//MARK: - 상단 바

struct MainTopBar: View {
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                SearchBar()
                Spacer()
                NavigationLink {
                    SavedPlaceListView(collections: mockSavedPlaces)
                } label: {
                    HeartButton()
                }
            } //h
            .padding(.bottom, 14)
            .padding(.trailing, 20)
            TopConvenientBar()
                .padding(.bottom, 21)
        }
        .padding(.leading, 20)
    }
    
}

#Preview {
    NavigationStack {
        MainMapView()
            .environment(NavigationRouter())
    }
}
