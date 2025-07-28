import SwiftUI

struct TopPlaceView: View {
    
    enum Category: String, CaseIterable, Identifiable {
        case favorite = "즐겨찾기 순"
        case search = "검색순"
        var id: Self { self }
    }

    @State private var selected: Category = .favorite
    @Namespace private var underlineNamespace

    let favoriteTop3 = ["카페1", "카페2", "카페3"]
    let searchTop3 = ["카페1", "카페2", "카페3"]

    var selectedTop3: [String] {
        switch selected {
        case .favorite: return favoriteTop3
        case .search: return searchTop3
        }
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("효창동 주변 TOP 3")
                .font(.mainTextSemibold20)
                .foregroundStyle(Color("gray-900"))
                .padding(.horizontal, 20)
                .padding(.bottom, 18)

            HStack(spacing: 14) {
                ForEach(Category.allCases) { category in
                    Button {
                        withAnimation(.easeInOut) {
                            selected = category
                        }
                    } label: {
                        VStack(spacing: 4) {
                            Text(category.rawValue)
                                .font(.mainTextSemibold14)
                                .foregroundStyle(Color("gray-900"))
                                .background(
                                    ZStack {
                                        if selected == category {
                                            Capsule()
                                                .fill(Color.black)
                                                .matchedGeometryEffect(id: "underline", in: underlineNamespace)
                                                .frame(height: 2.3)
                                                .offset(y: 5)
                                        }
                                    },
                                    alignment: .bottom
                                )
                        }
                    }
                }
            }

            .padding(.horizontal, 20)
            

            Divider()
                .padding(.horizontal)
            
            //MARK: TOP3 CARD

            ForEach(selectedTop3, id: \.self) { name in
                TopPlaceCard(zone: mockWaybleZoneResponse.data)
                    .padding(.horizontal, 3)
            }
            
//            ForEach(Array(selectedTop3.enumerated()), id: \.element) { index, name in
//                TopPlaceCard(zone: mockWaybleZoneResponse.data, rank: index + 1)
//                    .padding(.horizontal, 3)
//            }

        }
    }
}

#Preview {
    TopPlaceView()
}
