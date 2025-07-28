import SwiftUI

struct TagSelectorView: View {
    @Bindable var viewModel: FacilitySelectionViewModel
    
    private let rows: [[FacilityOption]] = [
        [.hasNoDoorStep, .floorInfo, .kindStaff],
        [.hasTableSeat, .hasDisabledToilet, .hasSlope]
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("경험하신 접근성 정보를 선택")
                .font(.mainTextSemibold14)
                .foregroundStyle(Color("gray-900"))
                .padding(.horizontal, 20)
            
            VStack(alignment: .leading, spacing: 12) {
                ForEach(rows, id: \.self) { row in
                    HStack {
                        ForEach(row) { option in
                            Button {
                                viewModel.toggle(option)
                            } label: {
                                TagButtonLabel(option: option, isSelected: viewModel.selected.contains(option))
                            }
                        }
                    }
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color("gray-300"), lineWidth: 1)
            )
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    TagSelectorView(viewModel: FacilitySelectionViewModel())
}


struct TagButtonLabel: View {
    let option: FacilityOption
    let isSelected: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            if !option.iconName.isEmpty {
                Image(option.iconName)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: 18, height: 18)
            }
            Text(option.rawValue)
                .font(.mainTextSemibold14)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(isSelected ? Color("blue-500") : Color("gray-100"))
        .foregroundStyle(isSelected ? .white : Color("gray-700"))
        .clipShape(Capsule())
    }
}
