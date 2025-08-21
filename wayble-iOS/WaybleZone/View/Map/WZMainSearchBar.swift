//
//  SearchBar.swift
//  wayble-iOS
//
//  Created by 햄무 on 7/12/25.
//


import SwiftUI

struct WZMainSearchBar: View {
    @Environment(NavigationRouter.self) var router
    @Environment(\.dismiss) private var dismiss
    //@EnvironmentObject var searchRoute: SearchRouteState
    @State private var searchText: String = ""
    @Binding var selectedIndex: Int
    
    var body: some View {
        
        HStack(spacing: 8) {
            // 1) 뒤로가기 버튼 (그대로 유지)
            WZBackButton(selectedIndex: $selectedIndex, toTab: 4)

            // 2) 검색 영역 버튼 (나머지 전부 차지)
            Button {
                router.push(.waybleZoneSearch)
            } label: {
                HStack {
                    Text("ex.숙대입구역 맛집")
                        .font(.mainTextRegular14)
                        .foregroundStyle(Color("gray-500"))
                        .tracking(-0.28)
                        .padding(.horizontal, 7)
                    Spacer()
                }
                .frame(height: 50)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color("gray-300"), lineWidth: 1)
                )
                .accessibilityLabel("검색")
                .accessibilityAddTraits(.isButton)
            }
            .buttonStyle(.plain)  // 기본 버튼 스타일 제거 (UI 유지용)
        }

        
        
//        HStack(spacing: 8) {
//            //            BackButton {
//            //                selectedIndex = 0
//            //            }
//            WZBackButton(selectedIndex: $selectedIndex, toTab: 4)
//            
//            Text("ex.숙대입구역 맛집")
//                .font(.mainTextRegular14)
//                .foregroundStyle(.gray500)
//                .tracking(-0.28)
//            Spacer()
//        }
//        .contentShape(Rectangle())
//        .frame(maxHeight: 50)
//        .frame(maxWidth: .infinity)
//        .background(
//            RoundedRectangle(cornerRadius: 15)
//                .stroke(Color.gray300, lineWidth: 1)
//        )
//        .onTapGesture {
//            Task { @MainActor in
//                
//                dismiss()
//                
//                
//                try? await Task.sleep(nanoseconds: 0)
//                router.reset()
//                
//                try? await Task.sleep(nanoseconds: 0)
//                withAnimation(.default) {
//                    selectedIndex = 4
//                }
//            }
//            
//        }
    }
}

/*#Preview {
    SearchBar().withRouter(selectedIndex: .constant(0),router: NavigationRouter())
}
*/
