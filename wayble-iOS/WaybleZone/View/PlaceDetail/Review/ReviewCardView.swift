import SwiftUI

struct ReviewCardView: View {
    let review: Review

    var body: some View {
        HStack(alignment: .top, spacing: 13) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .top, spacing: 8) {
                    Image("profile1")
                        .resizable()
                        .clipShape(Circle())
                        .frame(width: 39, height: 39)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(review.userNickname)
                            .font(.mainTextSemibold12)
                            .foregroundStyle(Color("gray-900"))

                        HStack(spacing: 2) {
                            ForEach(0..<5) { i in
                                Image(systemName: i < Int(review.rating) ? "star.fill" : "star")
                                    .resizable()
                                    .frame(width: 10, height: 10)
                                    .foregroundStyle(Color("blue-500"))
                            }

                            Rectangle()
                                .frame(width: 0.8, height: 7)
                                .foregroundStyle(Color("gray-500"))
                                .padding(.horizontal, 4)

                            Text(DayUtils.formatter.string(from: review.visitDate))
                                .font(.mainTextMedium10)
                                .foregroundStyle(Color("gray-500"))
                        }
                    }
                }

                Text(review.content)
                    .font(.mainTextRegular10)
                    .foregroundStyle(Color("gray-700"))
                    .lineLimit(3)
                    //.truncationMode(.tail) //넘치는 텍스트
                    .frame(maxHeight: 42)
                    .layoutPriority(1)
                   
                
                Spacer(minLength: 0)

                HStack(spacing: 4) {
                    Image("thumbsUp")
                    Text("\(review.likes)")
                        .font(.mainTextRegular09)
                        .foregroundStyle(Color("gray-900"))
                }
            }.frame(height: 104)
           

            if let imageName = review.images.first {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 104, height: 104)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .clipped()
            }
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color("gray-200"), lineWidth: 1)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.white)
                )
        )
        .frame(width: 350, height: 130)
        .padding(.horizontal, 20)
    }
}
#Preview {
    ReviewCardView(review:mockReviewListResponse.data[1])
}
