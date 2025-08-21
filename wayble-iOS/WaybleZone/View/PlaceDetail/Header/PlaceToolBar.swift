import SwiftUI

struct PlaceToolbar: View {
    @State private var showSheet = false
    @Binding var selectedIndex: Int
    
    let zone: WaybleZone
    
    var body: some View {
        
        HStack {
            
            WZBackButton(selectedIndex: $selectedIndex, toTab: 4)
            
            Spacer()
            
            HStack(spacing: 14) {
                Button {
                    
                } label: {
                    Image("share")
                }
                
                Button {
                    showSheet = true
                } label: {
                    Image("heart02")
                }.sheet(isPresented: $showSheet) {
                    SavePlaceSheetView(
                        zoneId: zone.id,
                        zoneName: zone.name, isPresented: $showSheet,
                        selectedIndex: $selectedIndex, vm: UserPlaceViewModel()
                    )
                    .presentationDetents([.fraction(0.45)])
                }
                
            }
        }
        .padding(.horizontal, 20)
    }
}

/*
 #Preview {
 PlaceToolbar(onBack: {}, onShare: {}).withRouter(selectedIndex: .constant(0))
 }
 */
