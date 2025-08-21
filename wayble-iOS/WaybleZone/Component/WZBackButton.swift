
//
//  BackButton.swift
//  wayble-iOS
//
//  Created by 햄무 on 7/12/25.
//

import SwiftUI

//struct WZBackButton: View {
//    @Environment(NavigationRouter.self) var router
//    @Binding var selectedIndex: Int
//    var toTab: Int = 0
//
//        
//    
//    var body: some View {
//        
//        Button(action: {
//     
//        //selectedIndex = 0
//            
//            withAnimation(.default) {
//              //  selectedIndex = 0
//                router.reset()
//                selectedIndex = toTab
//            }
//           // router.pop()
//        }) {
//            Image("back")
//                .foregroundStyle(.black)
//        }
//        
//        
//    }
//}
//


struct WZBackButton: View {
    @Environment(\.dismiss) private var dismiss      // ① 네이티브 pop
    @Environment(NavigationRouter.self) var router  // ② 커스텀 스택 reset
    @Binding var selectedIndex: Int
    var toTab: Int = 0

    var body: some View {
        Button {
                            withAnimation(.default) {
                                selectedIndex = toTab
                            }
          
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
//                    selectedIndex = toTab
//                }
//            }
        } label: {
            Image("back").foregroundStyle(.black)
        }
    }
}

