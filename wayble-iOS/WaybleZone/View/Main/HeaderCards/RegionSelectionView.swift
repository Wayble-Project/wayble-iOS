import SwiftUI

struct RegionSelectionView: View {
    @State private var showSheet = false

    @State private var selectedGu = "강남구"
    @AppStorage("selectedDong") private var selectedDong: String = "서초동"

    let guList = [
        "강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구", "노원구", "도봉구",
        "동대문구", "동작구", "마포구", "서대문구", "서초구", "성동구", "성북구", "송파구", "양천구", "영등포구",
        "용산구", "은평구", "종로구", "중구", "중랑구"
    ]

    let dongDict: [String: [String]] = [
        "강남구": ["개포동", "논현동", "대치동", "도곡동", "삼성동", "세곡동", "수서동", "신사동", "압구정동", "역삼동", "일원동", "청담동"],
        "강동구": ["강일동", "고덕동", "길동", "둔촌동", "명일동", "상일동", "성내동", "암사동", "천호동"],
        "강북구": ["미아동", "번동", "삼양동", "삼각산동", "송중동", "송천동", "수유동", "우이동", "인수동"],
        "강서구": ["가양동", "개화동", "공항동", "과해동", "내발산동", "등촌동", "마곡동", "방화동", "염창동", "우장산동", "화곡동"],
        "관악구": ["남현동", "대학동", "미성동", "보라매동", "봉천동", "삼성동", "서림동", "서원동", "성현동", "신림동", "신사동", "신원동", "은천동", "인헌동", "조원동", "중앙동", "청룡동", "청림동", "행운동"],
        "광진구": ["광장동", "구의동", "군자동", "능동", "자양동", "중곡동", "화양동"],
        "구로구": ["가리봉동", "개봉동", "고척동", "구로동", "수궁동", "신도림동", "오류동", "천왕동", "항동"],
        "금천구": ["가산동", "독산동", "시흥동"],
        "노원구": ["공릉동", "상계동", "월계동", "중계동", "하계동"],
        "도봉구": ["도봉동", "방학동", "쌍문동", "창동"],
        "동대문구": ["답십리동", "용신동", "이문동", "장안동", "전농동", "제기동", "청량리동", "회기동", "휘경동"],
        "동작구": ["노량진동", "대방동", "사당동", "상도동", "신대방동", "흑석동"],
        "마포구": ["공덕동", "대흥동", "도화동", "망원동", "상암동", "서강동", "서교동", "성산동", "신수동", "아현동", "연남동", "염리동", "용강동", "합정동"],
        "서대문구": ["남가좌동", "북가좌동", "북아현동", "신촌동", "연희동", "천연동", "충현동", "홍은동", "홍제동"],
        "서초구": ["내곡동", "반포동", "방배동", "서초동", "양재동", "잠원동"],
        "성동구": ["금호동", "마장동", "사근동", "성수동", "송정동", "옥수동", "왕십리도선동", "왕십리2동", "용답동", "행당동"],
        "성북구": ["길음동", "돈암동", "동선동", "보문동", "삼선동", "석관동", "성북동", "안암동", "월곡동", "장위동", "정릉동", "종암동"],
        "송파구": ["가락동", "거여동", "마천동", "문정동", "방이동", "삼전동", "석촌동", "송파동", "오금동", "오륜동", "위례동", "잠실동", "풍납동"],
        "양천구": ["목동", "신월동", "신정동"],
        "영등포구": ["당산동", "대림동", "도림동", "문래동", "신길동", "양평동", "여의동", "영등포동"],
        "용산구": ["남영동", "보광동", "서빙고동", "용문동", "용산동", "원효로동", "이촌동", "이태원동", "한강로동", "한남동", "효창동", "후암동"],
        "은평구": ["갈현동", "구산동", "대조동", "불광동", "수색동", "신사동", "역촌동", "응암동", "증산동", "진관동"],
        "종로구": ["가회동", "교남동", "무악동", "부암동", "사직동", "삼청동", "숭인동", "이화동", "종로동", "창신동", "청운효자동", "평창동", "혜화동"],
        "중구": ["광희동", "다산동", "동화동", "명동", "소공동", "신당동", "약수동", "을지로동", "장충동", "중림동", "청구동", "필동", "황학동"],
        "중랑구": ["망우동", "면목동", "묵동", "상봉동", "신내동", "중화동"]
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
