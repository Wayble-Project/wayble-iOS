//
//  BackButton.swift
//  wayble-iOS
//
//  Created by 햄무 on 7/12/25.
//

import SwiftUI

struct BackButton: View {
    @Environment(NavigationRouter.self) var router
    var action: (() -> Void)?   /// 외부에서 받을 추가 동작 0815
        
    
    var body: some View {
        
        Button(action: {
            action?()        /// 외부 동작 실행 0815
            router.pop()
        }) {
            Image("back")
                .foregroundStyle(.black)
        }
        
        
    }
}

/*#Preview {
    BackButton().withRouter(selectedIndex: .constant(0),
                            router: NavigationRouter())
}*/
