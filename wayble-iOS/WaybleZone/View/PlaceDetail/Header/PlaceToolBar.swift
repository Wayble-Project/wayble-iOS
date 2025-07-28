import SwiftUI

struct PlaceToolbar: View {
    let onBack: () -> Void
    let onShare: () -> Void
    let onLike: () -> Void

    var body: some View {
        
        HStack {

            BackButton()

            Spacer()

            HStack(spacing: 14) {
                Button(action: onShare) {
                    Image("share")
                }

                Button(action: onLike) {
                    Image("heart02")
                }
            }
        }
        .padding(.horizontal, 20)
    }
}
#Preview {
    PlaceToolbar(onBack: {}, onShare: {}, onLike: {}).withRouter(selectedIndex: .constant(0))
}
