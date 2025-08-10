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

    @State private var didRequest = false
    @State private var lastKey: String = ""
    @State private var showError = false
    @State private var errorMessage = ""

    var body: some View {
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
                    ForEach(viewModel.routes) { route in
                        WalkBox(
                            route: route,
                            onTap: {
                                print("✅ \(route.title) 선택됨")
                                viewModel.selectRoute(route)
                            },
                            isSelected: .constant(viewModel.selectedRoute.title == route.title)
                        )
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)   // ← 이 줄 추가
                .padding(.horizontal, 20)  
                .padding(.bottom, 56)
            }
        }
        .onAppear { triggerIfReady() }
        .onChange(of: selectedDeparture) { _ in triggerIfReady() }
        .onChange(of: selectedArrival) { _ in triggerIfReady() }
        .alert("경로를 찾을 수 없어요", isPresented: $showError) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(errorMessage)
        }
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
                errorMessage = err
                showError = true
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
