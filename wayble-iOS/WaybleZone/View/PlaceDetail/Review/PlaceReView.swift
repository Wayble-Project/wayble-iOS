import SwiftUI

struct PlaceReView: View {
    
    @State private var showAll: Bool = false
    
    let reviews: [Review]
    let onWrite: () -> Void
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 4) {
                Text("리뷰")
                    .font(.mainTextSemibold20)
                    .foregroundStyle(Color("gray-900"))
                    .padding(.trailing, 5)
                Image(systemName: "star.fill")
                    .foregroundStyle(Color("blue-500"))
                Text("4.5")
                    .font(.mainTextSemibold20)
                    .foregroundStyle(Color("gray-900"))
            }
            .padding(.horizontal, 20)

            Button(action: onWrite) {
                HStack(spacing: 4) {
                    Text("리뷰 작성하기")
                        .font(.mainTextSemibold14)
                        .foregroundStyle(Color("gray-900"))
                    Image("pencil")
                }
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("gray-300"), lineWidth: 1)
                )
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 15)
 
            VStack(spacing: 17) {
                ForEach(reviews) { review in
                    ReviewCardView(review: review)
                }
            }

            
            // 3개 이상일 때 더보기
            if reviews.count > 0 && !showAll {
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.15))
                        .frame(height: 1)

                    Button {
                        
                    } label: {
                        HStack(spacing: 4) {
                            Text("더보기")
                                .font(.mainTextSemibold14)
                                .foregroundStyle(Color("gray-900"))
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color("gray-700"))
                                .font(.system(size: 10))
                                .frame(width: 10, height: 5)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 6)
                        .background(Color("gray-100"))
                        .clipShape(Capsule())
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    PlaceReView(reviews: mockReviewListResponse.data, onWrite: {})
        .withRouter()
}
