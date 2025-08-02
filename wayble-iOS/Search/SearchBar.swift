//
//  SearchBar.swift
//  wayble-iOS
//
//  Created by 햄무 on 7/12/25.
//


import SwiftUI

struct SearchBar: View {
    @Environment(NavigationRouter.self) var router
    @State private var searchText: String = ""

    var body: some View {
      
            HStack(spacing: 8) {
                BackButton()

                TextField("ex.숙대입구역 맛집", text: $searchText)
                    .font(.pretend(type: .regular, size: 14))
                    .foregroundColor(Color("gray-500"))
                    .tracking(-0.28)
                    
                    
            }
            .frame(maxWidth: 290, maxHeight: 50)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color("gray-300"), lineWidth: 1)
            )
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            
            

    }
}


#Preview {
    SearchBar().withRouter(selectedIndex: .constant(0),router: NavigationRouter())
}
