import SwiftUI

struct SavedPlaceListView: View {
    @State private var selected = "최신순"
    @State var collections: [SavedPlace]
    @Binding var selectedIndex: Int
    

    var body: some View {
        VStack(alignment: .leading) {

            HStack() {
                BackButton(action: {
                    selectedIndex = 18
                })
                    .padding(.trailing, 5)
                
                Text("내가 저장한 장소")
                    .font(.mainTextSemibold20)
                    .foregroundStyle(Color("gray-900"))
                
                Spacer()
            }
            .padding(.horizontal, 20)

            WaybleZoneDropDown( options: ["최신순", "이름순"], selection: $selected)
                .padding(.vertical, 10)
                .padding(.top, 15)
                .padding(.leading, 20)
            
          
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(collections) { place in
                        NavigationLink {
                            SavedPlaceListCardView(place: place)
                        } label: {
                            
                        HStack(alignment: .center, spacing: 12) {
                            
                            Image("Place\(place.color)")
                                .resizable()
                                .frame(width: 36, height: 36)
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(place.title)
                                    .font(.mainTextSemibold14)
                                    .foregroundStyle(Color("gray-900"))
                                //                                Text("저장 장소 \(place.Count())")
                                Text("저장 장소 20")
                                    .font(.mainTextRegular12)
                                    .foregroundStyle(Color("gray-700"))
                            }
                            
                            Spacer()
                            
                            WaybleZoneSimpleDropDown(options: ["삭제", "편집"])
                        }
                        .padding(.horizontal, 20)
                    }
                }
                }
                .padding(.top, 10)
            }

 
            Button {
                // add
            } label: {
                Text("리스트 추가하기 +")
                    .font(.mainTextSemibold16)
                    .foregroundStyle(Color("gray-900"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
            }

            Spacer(minLength: 30)
        }
        .padding(.top, 20)
       
    }
}


#Preview {
    SavedPlaceListView(collections: mockSavedPlaces, selectedIndex: .constant(0)).withRouter(selectedIndex: .constant(0))
}
