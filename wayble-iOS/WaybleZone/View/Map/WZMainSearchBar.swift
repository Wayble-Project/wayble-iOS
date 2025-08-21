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
            //            BackButton {
            //                selectedIndex = 0
            //            }
            WZBackButton(selectedIndex: $selectedIndex, toTab: 4)
            
            Text("ex.숙대입구역 맛집")
                .font(.mainTextRegular14)
                .foregroundStyle(.gray500)
                .tracking(-0.28)
            Spacer()
        }
        .contentShape(Rectangle())
        .frame(maxHeight: 50)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(Color.gray300, lineWidth: 1)
        )
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
