//
//  BackButton.swift
//  wayble-iOS
//
//  Created by 햄무 on 7/12/25.
//

import SwiftUI

struct BackButton: View {
    @Environment(NavigationRouter.self) var router
    
    var body: some View {
        
        Button(action: {
            router.pop()
        }) {
            Image("back")
                .foregroundColor(.black)
        }
        
        
    }
}

#Preview {
    BackButton().withRouter()
}
