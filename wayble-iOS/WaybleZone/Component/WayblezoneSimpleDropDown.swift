import SwiftUI

struct WaybleZoneSimpleDropDown: View {
    let options: [String]
    
    @State private var isExpanded = false
    
    var body: some View {
        ZStack(alignment: .topLeading) {

            Button {
                isExpanded.toggle()
            } label: {
                HStack(spacing: 4) {
                    Image(systemName: "ellipsis")
                        .rotationEffect(.degrees(90))
                        .foregroundStyle(Color("gray-900"))
                        .frame(width: 24, height: 24)
                }
                
            }
            
            .overlay(alignment: .bottomTrailing){
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
                        .offset(x: -20, y: 10)
                        //.transition(.move(edge: .top).combined(with: .opacity))
                }
            }
            
            
            
        }
    }
    
    
    private var menu: some View {
        VStack(spacing: 0) {
            ForEach(options, id: \.self) { opt in
                Button {
                   //onDelete
                    withAnimation(.easeInOut) { isExpanded = false }
                } label: {
                    HStack(spacing: 25) {
                        Text(opt)
                            .font(.mainTextRegular14)
                            .foregroundStyle(
                                Color("gray-900")
                            )
                        Spacer()
                        
                    }
                    .padding(.horizontal, 10)
                    .frame(width: 100)
                    .frame(height: 40)
                }
                
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 13)
                .fill(Color.white)
                .stroke(Color("gray-300"), lineWidth: 1)
//                .shadow(color: .black.opacity(0.12),
//                        radius: 10,x:0, y: 0)
        )
        .offset(y: 50)
        .fixedSize()
        
    }
}


#Preview {
    return WaybleZoneSimpleDropDown(options: ["삭제", "편집"])
}

