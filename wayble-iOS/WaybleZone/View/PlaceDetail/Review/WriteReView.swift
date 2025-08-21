//import SwiftUI
//import PhotosUI
//
//struct WriteReView: View {
//    @Environment(NavigationRouter.self) var router
//    @Bindable var viewModel: FacilitySelectionViewModel
//
//    @Bindable var writeVM = WriteReviewViewModel()
//
//    let place: PlaceIdent
//
//
//    @State private var showModal = false
//
//    @State private var pickedItem: PhotosPickerItem?
//    @State private var pickedImage: Image?
//    @State private var rating: Int = 0
//    @State private var reviewText: String = ""
//
//    private let maxCharacters: Int = 1000
//
//    var body: some View {
//        ZStack {
//            ScrollView(.vertical) {
//                HStack {
//                    BackButton()
//                        .padding(.trailing, 12)
//
//                    Text("리뷰 작성")
//                        .font(.mainTextSemibold20)
//                        .foregroundStyle(Color("gray-900"))
//                    Spacer()
//                }
//                .padding(.horizontal, 20)
//
//                VStack(alignment: .leading, spacing: 20) {
//                    Text(place.name)
//                        .font(.mainTextSemibold24)
//                        .foregroundStyle(Color("gray-900"))
//                        .padding(.horizontal, 20)
//
//                    PhotosPicker(selection: $pickedItem, matching: .images) {
//                        ZStack {
//                            if let pickedImage {
//                                pickedImage
//                                    .resizable()
//                                    .scaledToFill()
//                            } else {
//                                VStack(spacing: 12) {
//                                    Image("share")
//                                        .resizable()
//                                        .frame(width: 24, height: 24)
//                                    Text("사진을 추가해주세요")
//                                        .font(.mainTextSemibold12)
//                                        .foregroundStyle(Color("gray-900"))
//                                }
//                            }
//                        }
//                        .frame(height: 184)
//                        .frame(maxWidth: .infinity)
//                        .cornerRadius(12)
//                        .clipped()
//                        .overlay(
//                            RoundedRectangle(cornerRadius: 12, style: .continuous)
//                                .stroke(Color("gray-300"), lineWidth: 1)
//                        )
//                        .padding(.horizontal, 20)
//                    }
//                    .onChange(of: pickedItem) { _, newValue in
//                        guard let newValue else { return }
//                        Task {
//                            if let data = try? await newValue.loadTransferable(type: Data.self),
//                               let uiImage = UIImage(data: data) {
//                                pickedImage = Image(uiImage: uiImage)
//                            }
//                        }
//                    }
//
//                    RatingView(rating: $rating)
//                    TagSelectorView(viewModel: viewModel)
//                    ReviewTextEditorView(reviewText: $reviewText, maxCharacters: maxCharacters)
//
//                    Button {
//                       
//                        onSave()
//                    } label: {
//                        Text("저장")
//                            .font(.mainTextSemibold14)
//                            .foregroundStyle(.white)
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color("darkblue-500"))
//                            .clipShape(RoundedRectangle(cornerRadius: 12))
//                            .padding(.horizontal, 20)
//                            .padding(.vertical, 23)
//                    }
//                }
//                .padding(.top)
//            }
//            .onChange(of: writeVM.successMessage) { _, msg in
//                guard msg != nil else { return }
//                withAnimation { showModal = true }
//            }
//            .alert(
//                "업로드 실패",
//                isPresented: Binding(
//                    get: { writeVM.submitError != nil },
//                    set: { _ in writeVM.submitError = nil }
//                )
//            ) {
//                Button("확인", role: .cancel) { writeVM.submitError = nil }
//            } message: {
//                Text(writeVM.submitError?.localizedDescription ?? "")
//            }
//
//            // MODAL
//            if showModal {
//                Color.black.opacity(0.7)
//                    .ignoresSafeArea()
//                    .onTapGesture { withAnimation { showModal = false } }
//
//                WaybleZoneModal(
//                    title: "소중한 리뷰가 작성되었어요!",
//                    buttonText: "홈으로",
//                    onButtonTap: {
//                        withAnimation { showModal = false }
//                        router.pop()
//                    }
//                )
//                .transition(.scale.combined(with: .opacity))
//                .zIndex(1)
//            }
//        }
//    }
//
//    private func onSave() {
//        Task { @MainActor in
//            // 중복 탭 방지
//            guard writeVM.isSubmitting == false else { return }
//
//            // 유효성
//            let text = reviewText.trimmingCharacters(in: .whitespacesAndNewlines)
//            guard rating > 0, !text.isEmpty else { return }
//
//            let facilities = Array(viewModel.selected.map(\.rawValue))
//            let visitDate  = Date.now.formatted(.iso8601.year().month().day()) // "yyyy-MM-dd"
//            var form = ReviewPostRequestModel(
//                content: text,
//                rating: rating,
//                visitDate: visitDate,
//                facilities: facilities,
//                images: []  
//            )
//
//            // 단일이어도 배열
//            let items: [PhotosPickerItem] = pickedItem.map { [$0] } ?? []
//            
//            
//            print("FORM: \(form)")
//            print("FORM: \(items)")
//
//
//            await writeVM.submit(
//                zoneID: place.id,
//                form: form,
//                photoItems: items.isEmpty ? nil : items
//            )
//        }
//    }
//
//}
//
////#Preview {
////    WriteReView(viewModel: FacilitySelectionViewModel(),  place: PlaceIdent(id: 1, name: "아임히어"))
////        .environment(NavigationRouter())
////}

import SwiftUI
import PhotosUI
import UIKit

struct WriteReView: View {
    // 라우터/의존성
    @Environment(NavigationRouter.self) var router
    @Bindable var viewModel: FacilitySelectionViewModel
    @Bindable var writeVM = WriteReviewViewModel()
    @Binding var selectedIndex: Int
    @Environment(\.dismiss) private var dismiss
    
    // 대상 장소
    let place: PlaceIdent

    // UI 상태
    @State private var showModal = false

    // 단일 이미지 선택
    @State private var pickedItem: PhotosPickerItem?
    @State private var pickedImage: Image?

    // 입력값
    @State private var rating: Int = 0
    @State private var reviewText: String = ""
    private let maxCharacters: Int = 1000

    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                // 상단바
                HStack {
                    WZBackButton(selectedIndex: $selectedIndex, toTab: 4)
                        .padding(.trailing, 12)

                    Text("리뷰 작성")
                        .font(.mainTextSemibold20)
                        .foregroundStyle(Color("gray-900"))
                    Spacer()
                }
                .padding(.horizontal, 20)

                VStack(alignment: .leading, spacing: 20) {
                    // 장소명
                    Text(place.name)
                        .font(.mainTextSemibold24)
                        .foregroundStyle(Color("gray-900"))
                        .padding(.horizontal, 20)

                    // 사진 선택 (단일)
                    PhotosPicker(
                        selection: $pickedItem,
                        matching: .images,
                        preferredItemEncoding: .compatible // HEIC 등 호환 변환
                    ) {
                        ZStack {
                            if let pickedImage {
                                pickedImage
                                    .resizable()
                                    .scaledToFill()
                            } else {
                                VStack(spacing: 12) {
                                    Image("share")
                                        .resizable()
                                        .frame(width: 24, height: 24)
                                    Text("사진을 추가해주세요")
                                        .font(.mainTextSemibold12)
                                        .foregroundStyle(Color("gray-900"))
                                }
                            }
                        }
                        .frame(height: 184)
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(12)
                        .clipped()
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .stroke(Color("gray-300"), lineWidth: 1)
                        )
                        .padding(.horizontal, 20)
                    }
                    .onChange(of: pickedItem) { _, newValue in
                        guard let newValue else { return }
                        Task { @MainActor in
                               do {
                                   // Data로 로드 → UIImage 복원 → SwiftUI.Image로 프리뷰
                                   if let data = try await newValue.loadTransferable(type: Data.self),
                                      let ui = UIImage(data: data) {
                                       pickedImage = Image(uiImage: ui)
                                   } else {
                                       pickedImage = nil
                                   }
                               } catch {
                                   pickedImage = nil
                               }
                           }
                    }

                    // 별점/태그/텍스트
                    RatingView(rating: $rating)
                    TagSelectorView(viewModel: viewModel)
                    ReviewTextEditorView(reviewText: $reviewText, maxCharacters: maxCharacters)

                    // 저장 버튼
                    Button {
                        onSave()
                    } label: {
                        ZStack {
                            Text(writeVM.isSubmitting ? "업로드 중..." : "저장")
                                .font(.mainTextSemibold14)
                                .foregroundStyle(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color("darkblue-500"))
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                            if writeVM.isSubmitting {
                                ProgressView().tint(.white)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 23)
                    .disabled(writeVM.isSubmitting)
                }
                .padding(.top)
            }
        

            // 성공 시 모달
            .onChange(of: writeVM.successMessage) { _, msg in
                guard msg != nil else { return }
                withAnimation { showModal = true }
            }

            // 실패 얼럿
            .alert(
                "업로드 실패",
                isPresented: Binding(
                    get: { writeVM.submitError != nil },
                    set: { _ in writeVM.submitError = nil }
                )
            ) {
                Button("확인", role: .cancel) { writeVM.submitError = nil }
            } message: {
                Text(writeVM.submitError?.localizedDescription ?? "")
            }

            // 커스텀 성공 모달
            if showModal {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation { showModal = false } }

                WaybleZoneModal(
                    title: "소중한 리뷰가 작성되었어요!",
                    buttonText: "홈으로",
                    onButtonTap: {
                        Task { @MainActor in
                    
                            dismiss()

             
                            try? await Task.sleep(nanoseconds: 0)
                            router.reset()

                            try? await Task.sleep(nanoseconds: 0)
                            withAnimation(.default) {
                                selectedIndex = 0
                            }
                        }
                        withAnimation { showModal = false }
                        //router.pop()
                    }
                )
                .transition(.scale.combined(with: .opacity))
                .zIndex(1)
            }
        }
    }

    private func onSave() {
        Task { @MainActor in
            // 중복 탭 방지
            guard writeVM.isSubmitting == false else { return }

            // 유효성
            let text = reviewText.trimmingCharacters(in: .whitespacesAndNewlines)
            guard rating > 0, !text.isEmpty else { return }

            // 폼 구성
            let facilities = Array(viewModel.selected.map(\.rawValue))
            let visitDate  = Date.now.formatted(.iso8601.year().month().day()) // "yyyy-MM-dd"

            var form = ReviewPostRequestModel(
                content: text,
                rating: rating,
                visitDate: visitDate,
                facilities: facilities,
                images: [] // 업로드 후 ViewModel에서 URL 채움
            )

            // 단일이어도 배열 형태로 전달
            let items: [PhotosPickerItem] = pickedItem.map { [$0] } ?? []

            print("FORM: \(form)")
            print("FORM Images Count: \(items.count)")

            await writeVM.submit(
                zoneID: place.id,
                form: form,
                photoItems: items.isEmpty ? nil : items
            )
        }
    }
}

// 필요 시 프리뷰
//#Preview {
//    WriteReView(
//        viewModel: FacilitySelectionViewModel(),
//        writeVM: WriteReviewViewModel(),
//        place: PlaceIdent(id: 1, name: "아임히어")
//    )
//    .environment(NavigationRouter())
//}
