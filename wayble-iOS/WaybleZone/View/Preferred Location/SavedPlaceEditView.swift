import SwiftUI

struct SavedPlaceEditView: View {
    @State private var selectedPlaceIDs: Set<Int> = []
    @State private var isAllSelected = false
    
    let savedPlace: SavedPlace
    
    var body: some View {
        VStack() {
            
            HStack {
                BackButton()
                Text("저장한 장소 편집")
                    .font(.mainTextSemibold20)
                    .foregroundStyle(Color("gray-900"))
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            
            HStack(spacing: 12) {
                Image("Place\(savedPlace.color)")
                    .resizable()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(savedPlace.title)
                        .font(.mainTextSemibold16)
                        .foregroundStyle(Color("gray-900"))
                    Text("저장 장소 \(savedPlace.waybleZone.count)")
                        .font(.mainTextRegular12)
                        .foregroundStyle(Color("gray-700"))
                }
                
                Spacer()
                
                Button {
                    // onEdit
                } label: {
                    Text("편집")
                        .font(.mainTextSemibold14)
                        .foregroundStyle(Color("gray-700"))
                        .padding(.horizontal, 25)
                        .padding(.vertical, 10)
                        .background(Color("gray-100"))
                        .clipShape(Capsule())
                }

            }
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            
            Divider()
            HStack {
                Button {
                    isAllSelected.toggle()
                    selectedPlaceIDs = isAllSelected
                    ? Set(savedPlace.waybleZone.map(\.id))
                    : []
                } label: {
                    Image( isAllSelected ? "check01" : "check05")
                        .resizable()
                        .frame(width: 24, height: 24)
                }.padding(.trailing, 8)
                
                Text("전체 선택")
                    .font(.mainTextSemibold16)
                    .foregroundStyle(Color("gray-900"))
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
            .padding(.bottom, 5)
            
            ScrollView {
                VStack(spacing: 24) {
                    ForEach(savedPlace.waybleZone) { zone in
                        HStack(alignment: .top) {
                            if selectedPlaceIDs.contains(zone.id) {
                                Button {
                                    selectedPlaceIDs.remove(zone.id)
                                } label: {
                                    Image("check01")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                             
                                }
                            } else {
                                Button {
                                    selectedPlaceIDs.insert(zone.id)
                                } label: {
                                    Image("check05")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                   
                                }
                            }

                            WaybleZoneCard(zone: zone)
                        }
                        .padding(.horizontal, 20)


                    }
                }
                .padding(.bottom, 20)
            }
            
            
            HStack(spacing: 16) {
                Button {
                    // onCancel
                } label: {
                    Text("취소")
                        .font(.mainTextSemibold16)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("gray-100"))
                        .foregroundStyle(Color("gray-700"))
                        .clipShape(RoundedRectangle(cornerRadius: 13))
                }
                
                Button {
                    // onDelete
                } label: {
                    Text("삭제")
                        .font(.mainTextSemibold16)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("darkblue-500"))
                        .foregroundStyle(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 13))
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .navigationBarHidden(true)
    }
}


#Preview {
    SavedPlaceEditView(savedPlace: mockSavedPlaces[0])
        .withRouter()
}
