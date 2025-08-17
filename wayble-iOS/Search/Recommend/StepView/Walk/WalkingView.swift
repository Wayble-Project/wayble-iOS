//
//  WalkingView.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/29/25.
//

import SwiftUI

struct WalkingView: View {
    @Bindable var viewModel: WalkViewModel
    @Binding var selectedDeparture: PlaceModel?
    @Binding var selectedArrival: PlaceModel?
    @State private var showLongView = false
    @State private var didRequest = false
    @State private var lastKey: String = ""
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
        Group {
            if showLongView {
                // LongView 전용 화면: 배경을 불투명하게 깔고 맵을 렌더링하지 않음
                ZStack {
                    Color.white
                        .ignoresSafeArea()
                    longView()
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
            } else {
                ZStack(alignment: .bottom) {
                    NaverMapViewWrapper(route: viewModel.selectedRoute)
                        .id(viewModel.mapRefreshTrigger)
                        .edgesIgnoringSafeArea(.all)

                    if viewModel.isLoading {
                        ProgressView("경로 불러오는 중…")
                            .padding()
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }

                    VStack {
                        Spacer()
                        HStack(spacing: 12) {
                            ForEach(Array(viewModel.routes.enumerated()), id: \.offset) { _, route in
                                WalkBox(
                                    route: route,
                                    onTap: {
                                        
                                        viewModel.selectRoute(route)
                                    },
                                    isSelected: .constant(viewModel.selectedRoute.title == route.title)
                                )
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 56)
                    }
                }
            }
        }
        .onAppear { triggerIfReady() }
        .onChange(of: selectedDeparture) { _ in triggerIfReady() }
        .onChange(of: selectedArrival) { _ in triggerIfReady() }
    }

    private func triggerIfReady() {
        guard !didRequest,
              let dep = selectedDeparture,
              let arr = selectedArrival else { return }

        let key = "\(dep.x ?? "")|\(dep.y ?? "")->\(arr.x ?? "")|\(arr.y ?? "")"
        guard key != lastKey else { return }
        lastKey = key
        didRequest = true

        Task {
            await viewModel.loadWalkingRoute(departure: dep, arrival: arr)

            if let err = viewModel.apiError {
                // 에러면 alert 대신 LongView 전환
                errorMessage = err
                showLongView = true
                showError = false
            } else {
                // 에러가 없으면 원래 화면
                showLongView = false
            }

            didRequest = false
        }
    }
}


#Preview {
    WalkingView(
        viewModel: WalkViewModel(),
        selectedDeparture: .constant(nil),
        selectedArrival: .constant(nil)
    )
}
