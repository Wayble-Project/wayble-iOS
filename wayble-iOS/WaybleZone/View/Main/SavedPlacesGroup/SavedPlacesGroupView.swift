import SwiftUI

struct SavedPlaceGroup: Identifiable {
    let id = UUID()
    let name: String
    let placeCount: Int
    let icon: String
}

enum SortOption: String, CaseIterable, Identifiable {
    case name = "이름순"
    case recent = "최신순"

    var id: String { rawValue }
}

struct SavedPlacesGroupView: View {
    @State private var selectedSort: SortOption = .name
    @State private var showAll: Bool = false

    let allGroups: [SavedPlaceGroup] = [
        SavedPlaceGroup(name: "학교 근처 카페", placeCount: 16,  icon: "PlacePurple"),
        SavedPlaceGroup(name: "카공 카페", placeCount: 5,  icon: "PlaceYellow"),
        SavedPlaceGroup(name: "남남", placeCount: 5,  icon: "PlaceRed"),
        SavedPlaceGroup(name: "스터디 카페", placeCount: 3, icon: "PlacePurple")
    ]

    var body: some View {
        Color("gray-100")
                .frame(height: 10)
                .frame(maxWidth: .infinity)
                .padding(.bottom, 20)
        
        VStack(alignment: .leading, spacing: 16) {

            Text("내가 저장한 장소")
                .font(.mainTextSemibold20)

            Menu {
                ForEach(SortOption.allCases) { option in
                    Button {
                        selectedSort = option
                    } label: {
                        HStack {
                            Text(option.rawValue)
                                .foregroundStyle(option == selectedSort ? Color("blue-700") : Color("gray-900"))

                            Spacer()

                            if option == selectedSort {
                                Image("check02")
//                                    .foregroundStyle(Color("blue-700"))
                            }
                        }
                    }
                }
            } label: {
                HStack {
                    Text(selectedSort.rawValue)
                        .font(.mainTextSemibold14)
                        .foregroundStyle(Color("gray-900"))
                    Image("down")
                }
            }

            // 그룹 리스트
            ForEach(displayedGroups) { group in
                HStack(spacing: 11) {
                   Image(group.icon)
                        .frame(width: 36, height: 36)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(group.name)
                            .font(.mainTextSemibold14)
                            .foregroundStyle(Color("gray-900"))
                        Text("저장 장소 \(group.placeCount)")
                            .font(.mainTextRegular12)
                            .foregroundStyle(Color("gray-700"))
                    }
                }
            }

            // 더보기 버튼(4개 이상)
            if allGroups.count > 3 && !showAll {
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
                        }
                       
            }
        } .padding(.horizontal, 20)
        
    }


    var sortedGroups: [SavedPlaceGroup] {
        switch selectedSort {
        case .name:
            return allGroups.sorted { $0.name < $1.name }
        case .recent:
            return allGroups.reversed() //timestamp로
        }
    }

    var displayedGroups: [SavedPlaceGroup] {
        showAll ? sortedGroups : Array(sortedGroups.prefix(3))
    }
}

#Preview {
    SavedPlacesGroupView()
}
