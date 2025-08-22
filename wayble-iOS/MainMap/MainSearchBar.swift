//
//  SearchBar.swift
//  wayble-iOS
//
//  Created by 햄무 on 7/12/25.
//


import SwiftUI

struct MainSearchBar: View {
    @Environment(NavigationRouter.self) var router
    @EnvironmentObject var searchRoute: SearchRouteState
    @State private var searchText: String = ""
    @Binding var selectedIndex: Int

    var body: some View {
        
        
        HStack(spacing: 8) {
            BackButton {
                selectedIndex = 0
            }
            
            Text("ex.숙대입구역 맛집")
                .font(.mainTextRegular14)
                .foregroundStyle(Color("gray-500"))
                .tracking(-0.28)
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            searchRoute.entryPoint = .home ///홈에서 열었다고 기록해두기 0818
            selectedIndex = 5
        }
        .frame(maxHeight: 50)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color("gray-300"), lineWidth: 1)
        )
    }
}


/*#Preview {
    SearchBar().withRouter(selectedIndex: .constant(0),router: NavigationRouter())
}
*/
