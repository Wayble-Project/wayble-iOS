import SwiftUI

enum WZCategory: String, CaseIterable, Identifiable, Hashable {
    case restaurant = "음식점"
    case cafe       = "카페"

    var id: Self { self }

    var customIcon: String {
        switch self {
        case .restaurant: return "food"
        case .cafe:       return "cafe"
        }
    }

    var zoneType: ZoneType {
        switch self {
        case .restaurant: return .RESTAURANT
        case .cafe:       return .CAFE
        }
    }
}

struct WZTopCategoryBar: View {
    var onSelect: (ZoneType?) -> Void = { _ in }
    @State private var selected: WZCategory? = .cafe

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(WZCategory.allCases) { cat in
                    CategoryTagLabel(
                        title: cat.rawValue,
                        customIcon: cat.customIcon,
                        isSelected: selected == cat
                    )
                    .onTapGesture {
                        if selected == cat {
                            selected = nil
                            onSelect(nil)
                        } else {
                            selected = cat
                            onSelect(cat.zoneType)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(height: 44)
    }
}

private struct CategoryTagLabel: View {
    let title: String
    let customIcon: String
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 6) {
            Image(customIcon)
                .resizable()
                .renderingMode(.template) // 템플릿 이미지면 틴트 적용
                .scaledToFit()
                .frame(width: 18, height: 18)
                .foregroundStyle(isSelected ? .black : Color("gray-500"))

            Text(title)
                .font(.mainTextSemibold14)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(isSelected ? Color(.white) : Color("gray-100"))
        .foregroundStyle(isSelected ? Color("darkblue-500") : Color("gray-500"))
        .clipShape(Capsule())
        .overlay(
                    Capsule()
                        .stroke(Color("gray-300"), lineWidth: 1)
                )
        .accessibilityLabel(Text(title))
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }
}
