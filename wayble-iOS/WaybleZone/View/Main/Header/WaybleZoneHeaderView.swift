import SwiftUI

struct WaybleZoneHeaderView: View {
   
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                HStack(spacing: 8) {
                    Image("waybleLogo3")

                    Text("wayble")
                        .font(.mainTextSemibold20)
                        .lineSpacing((20 * 1.4) - 20) // 140% line-height
                        .tracking(-0.4) // -2% of 20px = -0.4pt
                }

                Spacer()


                Button(action: {
                    //router.push(.searchView)
                    print("DEBUG: Search tapped")
                }) {
                    Image("search")
                        .frame(width: 24, height: 24)
                }
            }
            .padding(.top, 70)
            //.padding(.top, 44)
            .padding(.bottom, 22)
            .padding(.horizontal)

        }
        .background(Color("blue-50"))
    }
}


#Preview {
    WaybleZoneHeaderView()
}

