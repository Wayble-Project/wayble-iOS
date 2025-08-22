import SwiftUI

struct WaybleZoneModal: View {
    let title: String
    let buttonText: String
    let onButtonTap: () -> Void

    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                Image("WaybleLogo4")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)

                Text(title)
                    .font(.mainTextSemibold16)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color("gray-900"))

                Button(action: onButtonTap) {
                    Text(buttonText)
                        .font(.mainTextSemibold14)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .padding(.horizontal, 20)
                        .background(Color("blue-500"))
                        .clipShape(RoundedRectangle(cornerRadius: 13))
                }
            }
            .padding(20)
            .frame(maxWidth: 300, maxHeight: 200 )
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .shadow(radius: 12)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


    #Preview {
        ZStack {
            Color("black").opacity(0.7)
                .ignoresSafeArea()

            WaybleZoneModal(
                title: "소중한 리뷰가 작성되었어요!",
                buttonText: "홈으로",
                onButtonTap: {
                    print("홈으로 버튼 눌림")
                }
            )
        }
    }


