import SwiftUI

struct PlaceToolbar: View {
    @State private var showSheet = false
    
    let place = mockWaybleZoneResponse.data
    
    let onBack: () -> Void
    let onShare: () -> Void
    
    var body: some View {
        
        HStack {
            
            BackButton()
            
            Spacer()
            
            HStack(spacing: 14) {
                Button(action: onShare) {
                    Image("share")
                }
                
                Button {
                    showSheet = true
                } label: {
                    Image("heart02")
//                        .resizable()
//                        .frame(width: 24, height: 24)
                }.sheet(isPresented: $showSheet) {
                    SavePlaceSheetView(
                        zoneName: place.name,
                        collections: mockSavedPlaces
                    )
                    .presentationDetents([.fraction(0.45)])
                }
                
            }
        }
        .padding(.horizontal, 20)
    }
}
#Preview {
    PlaceToolbar(onBack: {}, onShare: {}).withRouter()
}
