//import SwiftUI
//
//enum WZCategory: String, CaseIterable, Identifiable, Hashable {
//    case restaurant = "음식점"
//    case cafe       = "카페"
//
//    var id: Self { self }
//
//    /// SF Symbol (프로젝트 에셋 쓰면 이름만 바꿔 끼우면 됨)
//    var systemIcon: String {
//        switch self {
//        case .restaurant: return "fork.knife"
//        case .cafe:       return "cup.and.saucer.fill"
//        }
//    }
//
//    /// 서버 파라미터/모델 매핑
//    var zoneType: ZoneType {
//        switch self {
//        case .restaurant: return .RESTAURANT
//        case .cafe:       return .CAFE
//        }
//    }
//}
//
//
//struct WZTopCategoryBar: View {
//    var onSelect: (ZoneType?) -> Void = { _ in }
//
//    @State private var selected: WZCategory? = .cafe   // 기본값 원하면 여기 변경
//
//    var body: some View {
//        ScrollView(.horizontal, showsIndicators: false) {
//            HStack(spacing: 12) {
//                ForEach(WZCategory.allCases) { cat in
//                    CategoryChip(
//                        title: cat.rawValue,
//                        systemIcon: cat.systemIcon,
//                        isSelected: selected == cat
//                    ) {
//                        if selected == cat {
//                            selected = nil              // 토글 해제 → 전체
//                            onSelect(nil)
//                        } else {
//                            selected = cat
//                            onSelect(cat.zoneType)     // CAFE/RESTAURANT 전달
//                        }
//                    }
//                }
//            }
//            .padding(.horizontal, 20)
//        }
//        .frame(height: 44)
//    }
//}
//
//private struct CategoryChip: View {
//    let title: String
//    let systemIcon: String
//    let isSelected: Bool
//    let action: () -> Void
//
//    var body: some View {
//        Button(action: action) {
//            HStack(spacing: 8) {
//                Image(systemName: systemIcon)
//                    .font(.system(size: 14, weight: .semibold))
//                Text(title)
//                    .font(.mainTextSemibold16)
//            }
//            .padding(.vertical, 8)
//            .padding(.horizontal, 14)
//            .background(
//                Capsule()
//                    .fill(isSelected ? Color.white : Color.clear)
//            )
//            .overlay(
//                Capsule()
//                    .stroke(isSelected ? Color("blue-700") : Color("gray-300"), lineWidth: isSelected ? 2 : 1)
//            )
//            .foregroundStyle(isSelected ? Color("blue-700") : Color("gray-900"))
//            .contentShape(Capsule())
//        }
//        .buttonStyle(.plain)
//    }
//}
import SwiftUI

// MARK: - 카테고리 (카페 / 음식점)
enum WZCategory: String, CaseIterable, Identifiable, Hashable {
    case restaurant = "음식점"
    case cafe       = "카페"

    var id: Self { self }

    // 아이콘 (SF Symbol 사용, 에셋으로 바꾸려면 Image(systemName:)만 교체)
    var systemIcon: String {
        switch self {
        case .restaurant: return "fork.knife"
        case .cafe:       return "cup.and.saucer.fill"
        }
    }

    // 서버 모델로 매핑
    var zoneType: ZoneType {
        switch self {
        case .restaurant: return .RESTAURANT
        case .cafe:       return .CAFE
        }
    }
}

// MARK: - 상단 카테고리 바 (TagSelector 스타일)
struct WZTopCategoryBar: View {
    var onSelect: (ZoneType?) -> Void = { _ in }       // nil = 전체 해제

    @State private var selected: WZCategory? = .cafe   // 기본 선택값 (원하면 nil 로 변경)

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(WZCategory.allCases) { cat in
                    CategoryTagLabel(
                        title: cat.rawValue,
                        systemIcon: cat.systemIcon,
                        isSelected: selected == cat
                    )
                    .onTapGesture {
                        if selected == cat {
                            selected = nil
                            onSelect(nil)                 // 토글 해제
                        } else {
                            selected = cat
                            onSelect(cat.zoneType)        // CAFE / RESTAURANT
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(height: 44)
    }
}

// MARK: - 태그 라벨 (TagSelectorView의 TagButtonLabel 스타일 차용)
private struct CategoryTagLabel: View {
    let title: String
    let systemIcon: String
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 6) {
            Image(systemIcon)
                .resizable()
                .scaledToFit()
                .frame(width: 18, height: 18)
                //.symbolRenderingMode(.monochrome)
                .foregroundStyle(isSelected ? .black : Color("gray-500"))

            Text(title)
                .font(.mainTextSemibold14)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(isSelected ? Color(.white) : Color("gray-100"))
        .foregroundStyle(isSelected ? .black : Color("gray-500"))
        .clipShape(Capsule())
        .accessibilityLabel(Text(title))
        .accessibilityAddTraits(isSelected ? [.isSelected] : [])
    }
}

// MARK: - Preview
#Preview {
    VStack(alignment: .leading, spacing: 16) {
        Text("카테고리 선택")
            .font(.mainTextSemibold14)
            .foregroundStyle(Color("gray-900"))
            .padding(.horizontal, 20)

        WZTopCategoryBar { _ in }
    }
    .padding(.top, 20)
    .background(Color.white)
}
