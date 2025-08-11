//
//  MapDetailView.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/25/25.
//

import SwiftUI
import NMapsMap

struct MapDetailView: View {
    let place: PlaceModel
    @Binding var selectedIndex: Int
    @Binding var searchBarViewID: UUID
    @Binding var selectedDeparture: PlaceModel?
    @Binding var selectedArrival: PlaceModel?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack(alignment: .top) {
           
            // 지도 + 고정 핀
            ZStack() {
                if let mapx = Double(place.x ?? ""),
                   let mapy = Double(place.y ?? "") {
                    
                    let lng = mapx / 10_000_000.0
                    let lat = mapy / 10_000_000.0

                    NaverMapView(centerX: lng, centerY: lat, zoomLevel: 20,showMarker: true) // 줌 레벨 지정
                }

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
                        .foregroundStyle(Color.black)

                    
                    Text("ex.숙대입구역 맛집")
                        .foregroundStyle(.gray500)
                        .font(.mainTextRegular14)
                        .padding(.leading, 4)
                }

                
                Spacer()
                
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .frame(maxWidth: .infinity, maxHeight: 50)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .inset(by: 0.5)
                    .stroke(Color.gray300, lineWidth: 1)
            )
            .padding(.horizontal, 20)
            .padding(.top, 12)
            if let zone = SearchViewModel.shared.waybleZones.first(where: { $0.name == place.title }) {
                VStack {
                    Spacer()
                    PlaceDetailView(zone: zone)
                }
            } else {
                VStack {
                    Spacer()
                    MapBoxView(
                        place: place,
                        selectedIndex: $selectedIndex,
                        selectedDeparture: $selectedDeparture,
                        selectedArrival: $selectedArrival
                    )
                }
            }
        }
        
        .onAppear {
            print("🧭 MapDetailView 헉 등장 - 전달된 place: \(place.title), x: \(place.x ?? "nil"), y: \(place.y ?? "nil")")
        }
        
    }
}

#Preview {
    MapDetailView(
        place: PlaceModel(
            title: "아임히어",
            roadAddress: "서울시 용산구 백범로 326 1층",
            x: "1269650571",
            y: "375381656",
            category: "카페>디저트>카페",
            isWaybleZone: true
        ),
        selectedIndex: .constant(0),
        searchBarViewID: .constant(UUID()),
        selectedDeparture: .constant(nil),
        selectedArrival: .constant(nil)
    )
}
