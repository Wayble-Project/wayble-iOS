import SwiftUI
import PhotosUI

struct WriteReView: View {
    @Environment(WaybleZoneNavigationRouter.self) var router
    @Bindable var viewModel: FacilitySelectionViewModel

    @Bindable private var writeVM = WriteReviewViewModel()

    let place: PlaceIdent


    @State private var showModal = false

    @State private var pickedItem: PhotosPickerItem?
    @State private var pickedImage: Image?
    @State private var rating: Int = 0
    @State private var reviewText: String = ""

    private let maxCharacters: Int = 1000

    var body: some View {
        ZStack {
            ScrollView(.vertical) {
                HStack {
                    BackButton()
                        .padding(.trailing, 12)

                    Text("리뷰 작성")
                        .font(.mainTextSemibold20)
                        .foregroundStyle(Color("gray-900"))
                    Spacer()
                }
                .padding(.horizontal, 20)

                VStack(alignment: .leading, spacing: 20) {
                    Text(place.name)
                        .font(.mainTextSemibold24)
                        .foregroundStyle(Color("gray-900"))
                        .padding(.horizontal, 20)

                    PhotosPicker(selection: $pickedItem, matching: .images) {
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
                        Task {
                            if let data = try? await newValue.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                pickedImage = Image(uiImage: uiImage)
                            }
                        }
                    }

                    RatingView(rating: $rating)
                    TagSelectorView(viewModel: viewModel)
                    ReviewTextEditorView(reviewText: $reviewText, maxCharacters: maxCharacters)

                    Button {
                       
                        onSave()
                    } label: {
                        Text("저장")
                            .font(.mainTextSemibold14)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color("darkblue-500"))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 23)
                    }
                }
                .padding(.top)
            }
            .onChange(of: writeVM.successMessage) { _, msg in
                guard msg != nil else { return }
                withAnimation { showModal = true }
            }
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

            // MODAL
            if showModal {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture { withAnimation { showModal = false } }

                WaybleZoneModal(
                    title: "소중한 리뷰가 작성되었어요!",
                    buttonText: "홈으로",
                    onButtonTap: {
                        withAnimation { showModal = false }
                        router.pop()
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

            let facilities = Array(viewModel.selected.map(\.rawValue))
            let visitDate  = Date.now.formatted(.iso8601.year().month().day()) // "yyyy-MM-dd"
            var form = ReviewPostRequestModel(
                content: text,
                rating: rating,
                visitDate: visitDate,
                facilities: facilities,
                images: []  
            )

            // 단일이어도 배열
            let items: [PhotosPickerItem] = pickedItem.map { [$0] } ?? []
            
            
            print("FORM: \(form)")
            print("FORM: \(items)")


            await writeVM.submit(
                zoneID: place.id,
                form: form,
                photoItems: items.isEmpty ? nil : items
            )
        }
    }

}

#Preview {
    WriteReView(viewModel: FacilitySelectionViewModel(),  place: PlaceIdent(id: 1, name: "아임히어"))
        .withWaybleZoneRouter().environment(NavigationRouter())
}
