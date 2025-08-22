import SwiftUI

struct WZBackButton: View {
    @Binding var selectedIndex: Int
    var toTab: Int = 0

    var body: some View {
        Button {
                            withAnimation(.default) {
                                selectedIndex = toTab
                            }

        } label: {
            Image("back").foregroundStyle(Color("black"))
        }
    }
}

