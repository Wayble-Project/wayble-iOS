import SwiftUI

struct ReviewCardView: View {
    let review: Review
    
    private let cardHeight: CGFloat = 130
    private let innerHeight: CGFloat = 104
    
    var body: some View {
        HStack(alignment: .top, spacing: 13) {
            VStack(alignment: .leading, spacing: 3) {
                HStack(alignment: .top, spacing: 8) {
                    let profiles = ["profile1", "profile2"]

                    Image(profiles.randomElement() ?? "profile1")
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
                            
//                            Text(DayUtils.formatter.string(from: review.visitDate))
//                                .font(.mainTextMedium10)
//                                .foregroundStyle(Color("gray-500"))
                            
                            Text(review.visitDate)
                                .font(.mainTextMedium10)
                                .foregroundStyle(Color("gray-500"))
                        }
                    }
                }.padding(.bottom, 10)
                
                
                Text(review.content)
                    .font(.mainTextRegular10)
                    .foregroundStyle(Color("gray-700"))
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
                    .layoutPriority(1)
                    .padding(.bottom, 8)
                
                
                Spacer(minLength: 0)
                
                
                HStack(spacing: 4) {
                    Image("thumbsUp")
                    Text("\(review.likes)")
                        .font(.mainTextRegular09)
                        .foregroundStyle(Color("gray-900"))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: innerHeight)
            
            
            if let imageName = review.images.first,
               let url = URL(string: imageName) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: innerHeight, height: innerHeight)

                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: innerHeight, height: innerHeight)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .clipped()

                    case .failure:
                        Image(systemName: "photo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: innerHeight, height: innerHeight)
                            .foregroundColor(.gray)

                    @unknown default:
                        EmptyView()
                    }
                }
            }

        }
        .frame(maxWidth: .infinity)
        .frame(height: cardHeight)
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color("gray-200"), lineWidth: 1)
                )
        )
        .padding(.horizontal, 20)
    }
}

#Preview {
    ReviewCardView(review: mockReviewListResponse.data[1])
}
