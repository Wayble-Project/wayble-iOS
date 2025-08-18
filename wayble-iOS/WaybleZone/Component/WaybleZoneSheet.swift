import SwiftUI

struct SavePlaceSheetView: View {
    let zoneName: String
    @State var collections: [SavedPlace]
    @State var selectedIDs: Set<Int> = []

    var body: some View {
        VStack(alignment: .leading) {
            Capsule()
                .frame(width: 98, height: 6)
                .foregroundStyle(Color("gray-300"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)

            Text(zoneName)
                .font(.mainTextSemibold24)
                .foregroundStyle(Color("gray-900"))
                .padding(.top, 6)
                .padding(.horizontal, 20)

            List {
                ForEach(collections) { place in
                    Button {
                        toggleSelection(id: place.placeID)
                    } label: {
                        HStack(spacing: 11) {
                            Image("Place\(place.color)")
                                .resizable()
                                .frame(width: 36, height: 36)
                                .clipShape(Circle())

                            VStack(alignment: .leading, spacing: 5) {
                                Text(place.title)
                                    .font(.mainTextSemibold14)
                                    .foregroundStyle(Color("gray-900"))
                                Text("저장 장소 \(Int.random(in: 1...20))") //count
                                    .font(.mainTextRegular12)
                                    .foregroundStyle(Color("gray-700"))
                            }

                            Spacer()

                            Image(selectedIDs.contains(place.placeID) ? "check05" : "check01")
                                .resizable()
                                .frame(width: 24, height: 24)
                                
                        }
                    }
                } .listRowSeparator(.hidden)
            }
            .listStyle(.plain)
            .padding(Edge.Set.bottom, 16)

            Button {
                saveSelections()
            } label: {
                Text("저장")
                    .font(.mainTextSemibold16)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("darkblue-700"))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 30)
            }
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .ignoresSafeArea(.all, edges: .bottom)
    }

    private func toggleSelection(id: Int) {
        if selectedIDs.contains(id) {
            selectedIDs.remove(id)
        } else {
            selectedIDs.insert(id)
        }
    }

    private func saveSelections() {
        print("\(selectedIDs)")
       //pop
    }
}

#Preview {
    SavePlaceSheetView(
            zoneName: mockWaybleZoneResponse.data.name,
            collections: mockSavedPlaces
        )
}
