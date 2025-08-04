//
//  OnlyMapView.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/27/25.
//

//FIXME: - .onChange -> 깃허브 수정할 때 /* */ 이 주석 처리가 애매해서 원래 코드가 뭔지 모르겠음!!
//FIXME: - 이거 고치면서 .onChange(deprecated) 수정하면 좋을 듯!! (수정한 거라 주석 처리한 건가?)


import SwiftUI
import NMapsMap

//지도만 보기 + 줌 이동 X + 다른 장소로 이동하면 그 장소 title, category,roadAddress 보여주기
struct OnlyMapView: View {
    @Binding var place: PlaceModel
    @Binding var selectedIndex: Int
    @Binding var searchBarViewID: UUID
    @Environment(\.dismiss) private var dismiss

    @State private var placeTitle: String = ""
    @State private var placeRoadAddress: String = ""
    @State private var placeCategory: String = ""

    @StateObject private var locationManager = LocationManager()
    struct MapCenter: Equatable {
        var latitude: Double
        var longitude: Double
    }
    @State private var mapCenter: NMGLatLng = NMGLatLng(lat: 37.5665, lng: 126.9780)

    @State private var viewModel = SearchViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            // 지도 + 고정 핀
            
            ZStack() {
                NaverMapView(
                    centerX: centerLng,
                    centerY: centerLat,
                    onLocationChanged: { newLat, newLng in
                        mapCenter = NMGLatLng(lat: newLat, lng: newLng)
                        viewModel.handleCenterChanged(lat: newLat, lng: newLng)
                    },
                    zoomLevel: 16,
                    showMarker: false
                    
                )
                
                Image("pin11")
                    .frame(width: 46, height: 58.78)
            }
            
            // 상단 검색창
            HStack {
                Button(action: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        selectedIndex = 5
                        searchBarViewID = UUID()
                        dismiss()
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                    
                    Text("ex.숙대입구역 맛집")
                        .foregroundColor(.gray500)
                        .font(.mainTextRegular14)
                        .padding(.leading, 4)
                }
                
                
                Spacer()
                
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(Color.white)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .inset(by: 0.5)
                    .stroke(Color.gray300, lineWidth: 1)
            )
            .padding(.horizontal, 20)
            .padding(.top, 12)
            VStack {
                Spacer()
                DynamicMapBoxView(
                    place: place,
                    title: $placeTitle,
                    roadAddress: $placeRoadAddress,
                    category: $placeCategory
                )
            }
        }
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading, content: {
                
            })
            
            ToolbarItem(placement: .principal, content: {
                
            })
        })
        /*
        .onAppear {
            #if !targetEnvironment(simulator)
            if let coord = locationManager.currentCoordinate {
                mapCenter = NMGLatLng(lat: coord.latitude, lng: coord.longitude)
            }
            #endif
        }
         */
        .onChange(of: viewModel.selectedPlace) { newPlace in
            guard let place = newPlace, place != self.place else { return }

            DispatchQueue.main.async {
                self.place = place
                self.placeTitle = place.title
                self.placeRoadAddress = place.roadAddress
                self.placeCategory = place.category.components(separatedBy: ">").last ?? place.category
            }
        }

    }
}

extension OnlyMapView {
    private var centerLat: Double {
        return mapCenter.lat
    }
    
    private var centerLng: Double {
        return mapCenter.lng
    }
}

#Preview {
    OnlyMapView(
        place: .constant(PlaceModel(
            title: "아임히어",
            roadAddress: "서울시 용산구 백범로 326 1층",
            x: "1269650571",
            y: "375381656",
            category: "카페>디저트>카페",
            isWaybleZone: true
        )),
        selectedIndex: .constant(0),
        searchBarViewID: .constant(UUID())
    )
}
