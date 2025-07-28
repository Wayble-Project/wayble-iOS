import SwiftUI

struct RatingView: View {
    @Binding var rating: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("별점 평가")
                .font(.mainTextSemibold14)
                .foregroundStyle(Color("gray-900"))
            
            HStack(spacing: 5) {
                ForEach(1...5, id: \.self) { index in
                    Button {
                        rating = index
                    } label: {
                        Image(rating >= index ? "blueStar" : "grayStar")
                            .resizable()
                            .frame(width: 24, height: 24)
                    }
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color("gray-300"), lineWidth: 1)
            )
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    StatefulPreviewWrapper(3) { binding in
        RatingView(rating: binding)
    }
}
