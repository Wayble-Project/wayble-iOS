import SwiftUI

struct RegionSelectionView: View {
    @State private var showSheet = false

    @State private var selectedGu = "강남구"
    @AppStorage("selectedDong") private var selectedDong: String = "개포 1동"

    let guList = ["강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구"]
    let dongDict: [String: [String]] = [
        "강남구": ["개포 1동", "논현 1동", "대치 1동", "대치 2동"],
        "강동구": ["개포 2동"],
        "강북구": ["개포 3동"],
        "강서구": ["논현 1동"],
        "관악구": ["논현 2동"],
        "광진구": ["대치 1동"],
        "구로구": ["대치 2동"]
    ]

    var body: some View {
        VStack(alignment: .leading) {
            Button {
                showSheet = true
            } label: {
                HStack(spacing: 6) {
                    Image("location")
                    Text(displayRegion)
                        .font(.mainTextSemibold14)
                        .foregroundStyle(Color("gray-900"))
                    Image("down").frame(width: 24, height: 24)
                }
            }
            .sheet(isPresented: $showSheet) {
                RegionSheetView(
                    selectedGu: $selectedGu,
                    selectedDong: $selectedDong,
                    guList: guList,
                    dongDict: dongDict
                )
                .presentationDetents([.fraction(0.6)])
            }
            .font(.mainTextSemibold16)
            .foregroundStyle(Color("gray-700"))
        }
        .padding(.horizontal, 20)
    }
}

//MARK: SheetView

struct RegionSheetView: View {
    @Binding var selectedGu: String
    @Binding var selectedDong: String

    let guList: [String]
    let dongDict: [String: [String]]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Capsule()
                .frame(width: 98, height: 6)
                .foregroundColor(Color("gray-300"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)

            Text("관심 지역 설정")
                .font(.mainTextSemibold20)
                .foregroundStyle(Color("gray-900"))
                .padding(.horizontal, 20)
                .padding(.vertical, 15)
                .padding(.top, 10)

            Divider()

            HStack(spacing: 0) {
                VStack(spacing: 0) {
                    Text("구")
                        .font(.mainTextSemibold16)
                        .foregroundStyle(Color("gray-700"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color("gray-100"))

                    List {
                        ForEach(guList, id: \.self) { gu in
                            HStack {
                                Text(gu)
                                    .font(.mainTextSemibold16)
                                    .foregroundStyle(selectedGu == gu ? Color("blue-900") : Color("gray-900"))
                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedGu = gu
                                selectedDong = dongDict[gu]?.first ?? ""
                            }
                            .listRowBackground(selectedGu == gu ? Color("blue-50") : Color.clear)
                        }
                    }
                    .listStyle(.plain)
                }
                .frame(width: 160)

                Divider()

                VStack(spacing: 0) {
                    Text("동")
                        .font(.mainTextSemibold16)
                        .foregroundStyle(Color("gray-700"))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(Color("gray-100"))

                    List {
                        ForEach(dongDict[selectedGu] ?? [], id: \.self) { dong in
                            HStack {
                                Text(dong)
                                    .font(.mainTextSemibold16)
                                    .foregroundStyle(selectedDong == dong ? Color("blue-900") : Color("gray-900"))
                                Spacer()
                            }
                            .padding(.vertical, 8)
                            .contentShape(Rectangle())
                            .onTapGesture { selectedDong = dong }
                            .listRowBackground(selectedDong == dong ? Color("blue-50") : Color.clear)
                        }
                    }
                    .listStyle(.plain)
                }
            }
        }
    }
}

#Preview {
    RegionSelectionView()
}

private extension RegionSelectionView {
    var displayRegion: String {
        
            let dong = selectedDong.trimmingCharacters(in: .whitespaces)
            if dong.isEmpty { return "관심 지역 선택" }

            return "\(dong)"
        }
    
}
