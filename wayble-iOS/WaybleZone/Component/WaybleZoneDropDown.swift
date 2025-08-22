import SwiftUI

struct WaybleZoneDropDown: View {
    let options: [String]
    @Binding var selection: String
    
    @State private var isExpanded = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            //            주변 누르면 드롭다운 해제
            //            if isExpanded {
            //                Color.black.opacity(0.001)
            //                    .ignoresSafeArea()
            //                    .onTapGesture {
            //                        withAnimation {
            //                            isExpanded = false
            //                        }
            //                    }
            //            }
            
            Button {
                isExpanded.toggle()
            } label: {
                HStack(spacing: 4) {
                    Text(selection)
                        .font(.mainTextSemibold14)
                        .foregroundStyle(Color("gray-900"))
                    Image("down")
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .foregroundStyle(Color("gray-700"))
                }
                
            }
            
            .overlay(alignment: .bottomLeading){
                if isExpanded {
                    
                    Color.black.opacity(0.001)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation {
                                isExpanded = false
                            }
                        }
                    
                    menu
                        .frame(width: 102)
                        .offset(y: 38)
                        .transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            
            
            
        }.zIndex(1)
    }
    
    
    private var menu: some View {
        VStack(spacing: 0) {
            ForEach(options, id: \.self) { opt in
                Button {
                    selection = opt
                    withAnimation(.easeInOut) { isExpanded = false }
                } label: {
                    HStack(spacing: 25) {
                        Text(opt)
                            .font(.mainTextSemibold14)
                            .foregroundStyle(
                                selection == opt ? Color("blue-700")
                                : Color("gray-900")
                            )
                        Spacer()
                        if selection == opt {
                            Image("check02")
                                .resizable()
                                .renderingMode(.template)
                                .scaledToFit()
                                .frame(width: 16, height: 16)
                                .foregroundStyle(Color("blue-700"))
                            
                        }
                    }
                    .padding(.horizontal, 10)
                    .frame(height: 40)
                }
                
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white)
                .shadow(color: Color("black").opacity(0.12),
                        radius: 10,x:0, y: 0)
        )
        .offset(y: 50)
        .fixedSize()
        
    }
}


#Preview {
    @State var sort = "추천순"
    return WaybleZoneDropDown(options: ["추천순", "최신순"], selection: $sort)
}

