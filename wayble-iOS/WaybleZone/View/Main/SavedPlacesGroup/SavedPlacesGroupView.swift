import SwiftUI

struct SavedPlacesGroupView: View {
    @State var collections: [SavedPlace]

    @State private var showAll: Bool = false
    @State private var selected = "최신순"


    var body: some View {
        Color("gray-100")
                .frame(height: 10)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)
        
        VStack(alignment: .leading, spacing: 16) {

            Text("내가 저장한 장소")
                .font(.mainTextSemibold20)
            
            WaybleZoneDropDown( options: ["최신순", "이름순"], selection: $selected)
                .padding(.vertical, 5)
                .padding(.bottom, 5)


            // 그룹 리스트
            ForEach(collections) { place in
                HStack(spacing: 11) {
                   Image("Place\(place.color)")
                        .frame(width: 36, height: 36)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(place.title)
                            .font(.mainTextSemibold14)
                            .foregroundStyle(Color("gray-900"))
                        Text("저장 장소 \(Int.random(in: 1...20))")
                            .font(.mainTextRegular12)
                            .foregroundStyle(Color("gray-700"))
                    }
                }
            }

            // 더보기 버튼(4개 이상)
            if collections.count > 2 && !showAll {
                ZStack {
                
                            Rectangle()
                                .fill(Color("gray-200"))
                                .frame(height: 1)

                            Button {
                              
                            } label: {
                                HStack(spacing: 4) {
                                    Text("더보기")
                                        .font(.mainTextSemibold14)
                                        .foregroundStyle(Color("gray-900"))
                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(Color("gray-700"))
                                        .frame(width: 10, height: 5)
                                    
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 6)
                                .background(Color("gray-100"))
                                .clipShape(Capsule())
                            }
                        } .padding(.top, 10)
                       
            }
        } .padding(.horizontal, 20)
           
        
    }


//    var sortedGroups: [SavedPlaceGroup] {
//        switch selectedSort {
//        case .name:
//            return allGroups.sorted { $0.name < $1.name }
//        case .recent:
//            return allGroups.reversed() //timestamp로
//        }
//    }


}

#Preview {
    SavedPlacesGroupView(collections: mockSavedPlaces)
}
