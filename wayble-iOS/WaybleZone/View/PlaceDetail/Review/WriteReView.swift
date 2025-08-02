import SwiftUI
import PhotosUI

struct WriteReView: View {
    @Bindable var viewModel: FacilitySelectionViewModel
    
    @State private var showModal = false
    
    @State private var pickedItem: PhotosPickerItem?
    @State private var pickedImage: Image?
    @State private var rating: Int = 0
    @State private var reviewText: String = ""
    
    
    private let maxCharacters: Int = 1000
    
    var body: some View {
        ZStack {
            
            ScrollView(.vertical) {
                HStack() {
                    BackButton()
                        .padding(.trailing, 12)
                    
                    Text("리뷰 작성")
                        .font(.mainTextSemibold20)
                        .foregroundStyle(Color("gray-900"))
                    Spacer()
                }
                .padding(.horizontal, 20)
                VStack(alignment: .leading, spacing: 20) {
                    Text("아임히어")
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
                        withAnimation {
                            showModal = true
                        }
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
            
            //MODAL
            if showModal {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            showModal = false
                        }
                    }
                
                WaybleZoneModal(
                    title: "소중한 리뷰가 작성되었어요!",
                    buttonText: "홈으로",
                    onButtonTap: {
                        withAnimation {
                            showModal = false
                        }
                        //pop
                    }
                )
                .transition(.scale.combined(with: .opacity))
                .zIndex(1)
            }
            
            
        }
        
    }
    
    
    
    private func onSave() {
        
    }
}



#Preview {
    WriteReView(viewModel: FacilitySelectionViewModel()).withRouter()
}
