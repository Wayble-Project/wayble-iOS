//import SwiftUI
//
//@Observable
//class AddListViewModel {
//    var title: String = ""
//    var selectedColor: String = "Red"
//    
//    let colorOptions: [String] = ["Red", "Orange", "Yellow", "Green", "Blue", "Purple"]
//    
//    func saveList() {
//        print("리스트 저장됨: \(title), 색상: \(selectedColor)")
//    }
//}
//
//struct AddListView: View {
//    @Bindable var viewModel = AddListViewModel()
//    
//    var body: some View {
//        VStack(alignment: .leading) {
//            HStack() {
//                BackButton()
//                    .padding(.trailing, 12)
//                
//                Text("새 리스트 생성")
//                    .font(.mainTextSemibold20)
//                    .foregroundStyle(Color("gray-900"))
//                Spacer()
//            }
//            .padding(.horizontal, 20)
//            .padding(.vertical, 15)
//            
//
//            VStack(alignment: .leading, spacing: 15) {
//                Text("이름")
//                    .font(.mainTextSemibold14)
//                    .foregroundStyle(Color("gray-900"))
//                
//                TextField(
//                    text: $viewModel.title,
//                    prompt: Text("새 리스트 명을 작성해주세요")
//                        .font(.mainTextRegular14) // placeholder
//                        .foregroundStyle(Color("gray-500")) // placeholder
//                ) {
//                    EmptyView() // onEditingChanged (필요하면 넣기)
//                }
//                .font(.mainTextRegular14)
//                .padding()
//                .background(
//                    RoundedRectangle(cornerRadius: 15)
//                        .stroke(Color("gray-200"), lineWidth: 1)
//                )
//
//            }
//            .padding(.horizontal, 20)
//            .padding(.top, 20)
//            
//
//            VStack(alignment: .leading, spacing: 12) {
//                Text("색상 선택")
//                    .font(.mainTextSemibold14)
//                    .foregroundStyle(Color("gray-900"))
//                
//                HStack(spacing: 12) {
//                    ForEach(viewModel.colorOptions, id: \.self) { color in
//                        Button {
//                            viewModel.selectedColor = color
//                        } label: {
//                            Image("Place\(color)")
//                                .resizable()
//                                .frame(width: 36, height: 36)
//                                .overlay(
//                                    Circle()
//                                        .stroke(viewModel.selectedColor == color ? Color("gray-900") : .clear, lineWidth: 2)
//                                )
//                        }
//                    }
//                }
//            }
//            .padding(.horizontal, 20)
//            .padding(.top, 32)
//            
//            Spacer()
//            
//            Button {
//                viewModel.saveList()
//            } label: {
//                Text("저장")
//                    .font(.headline)
//                    .foregroundStyle(.white)
//                    .frame(maxWidth: .infinity)
//                    .frame(height: 55)
//                    .background(Color("darkblue-500"))
//                    .clipShape(RoundedRectangle(cornerRadius: 16))
//            }
//            .padding(.horizontal, 20)
//            .padding(.bottom, 30)
//
//        }
//    }
//}
//
//#Preview {
//    AddListView().environment(NavigationRouter())
//}
import SwiftUI

// 폼 전용 로컬 상태 (그대로 사용)
@Observable
class AddListViewModel {
    var title: String = ""
    var selectedColor: String = "Red"

    let colorOptions: [String] = ["RED", "ORANGE", "YELLOW", "GREEN", "BLUE", "PURPLE"]
}

struct AddListView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var selectedIndex: Int
    // ✅ UserPlaceViewModel 주입 받아서 실제 API 호출
    @Bindable var userPlaceVM: UserPlaceViewModel
    // 폼 상태는 로컬로 관리
    @State private var form = AddListViewModel()

    var body: some View {
        VStack(alignment: .leading) {
            // 헤더
            HStack {
                WZBackButton(selectedIndex: $selectedIndex, toTab: 4).padding(.trailing, 12)
                Text("새 리스트 생성")
                    .font(.mainTextSemibold20)
                    .foregroundStyle(Color("gray-900"))
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)

            // 입력: 이름
            VStack(alignment: .leading, spacing: 15) {
                Text("이름")
                    .font(.mainTextSemibold14)
                    .foregroundStyle(Color("gray-900"))

                TextField(
                    text: $form.title,
                    prompt: Text("새 리스트 명을 작성해주세요")
                        .font(.mainTextRegular14)
                        .foregroundStyle(Color("gray-500"))
                ) { }
                .font(.mainTextRegular14)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color("gray-200"), lineWidth: 1)
                )
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)

            // 입력: 색상 선택
            VStack(alignment: .leading, spacing: 12) {
                Text("색상 선택")
                    .font(.mainTextSemibold14)
                    .foregroundStyle(Color("gray-900"))

                HStack(spacing: 12) {
                    ForEach(form.colorOptions, id: \.self) { color in
                        Button {
                            form.selectedColor = color
                        } label: {
                            Image("Place\(color)")
                                .resizable()
                                .frame(width: 36, height: 36)
                                .overlay(
                                    Circle()
                                        .stroke(form.selectedColor == color ? Color("gray-900") : .clear, lineWidth: 2)
                                )
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 32)

            Spacer()

            // 저장 버튼
            Button {
                Task { @MainActor in
                    // 간단 유효성 검사
                    let title = form.title.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !title.isEmpty else {
                        userPlaceVM.errorMessage = "리스트 이름을 입력해주세요."
                        return
                    }

                    await userPlaceVM.save(title: title, color: form.selectedColor)

                    // 성공 시 닫기(또는 필요에 따라 reset)
                    if userPlaceVM.errorMessage == nil {
                        dismiss()
                    }
                }
            } label: {
                ZStack {
                    if userPlaceVM.isSaving {
                        ProgressView()
                            .frame(maxWidth: .infinity, minHeight: 55)
                    } else {
                        Text("저장")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, minHeight: 55)
                    }
                }
                .background(Color("darkblue-500"))
                .clipShape(RoundedRectangle(cornerRadius: 16))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 30)
            .disabled(userPlaceVM.isSaving)

        }
        // 실패 알림
        .alert(
            "업로드 실패",
            isPresented: Binding(
                get: { userPlaceVM.errorMessage != nil },
                set: { _ in userPlaceVM.errorMessage = nil }
            )
        ) {
            Button("확인", role: .cancel) { userPlaceVM.errorMessage = nil }
        } message: {
            Text(userPlaceVM.errorMessage ?? "")
        }
        // 성공 알림(원하면 닫기 대신 토스트/스낵바로 전환 가능)
        .alert(
            "완료",
            isPresented: Binding(
                get: { userPlaceVM.successMessage != nil },
                set: { _ in userPlaceVM.successMessage = nil }
            )
        ) {
            Button("확인") {
                userPlaceVM.successMessage = nil
                dismiss()
            }
        } message: {
            Text(userPlaceVM.successMessage ?? "장소가 저장되었습니다.")
        }
    }
}

//#Preview {
//    // 미리보기용 목업 VM 주입
//    AddListView(userPlaceVM: UserPlaceViewModel())
//        .environment(NavigationRouter())
//}
