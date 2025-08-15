import SwiftUI
import Foundation

struct CommonStepView: View {
    let step: RouteStep
    @Bindable var viewModel = TransportationViewModel()
    @State private var isSimpleMode = false
    
    var body: some View {
        ScrollView {
            HStack {
                VStack(spacing:0) {
                    VStack(alignment: .leading) {
                        HStack(alignment: .top, spacing: 12) {

                            VStack(spacing: 0) {
                                stepImage(for: step)
                                    
                                Spacer()
                                    .frame(height:1)
                                Text(step.title)
                                    .font(.mainTextSemibold12)
                                    .foregroundStyle(step.title.contains("출발") ? Color.positive : Color.black)
                                Spacer()
                                    .frame(height:4)
                                
                                let color: Color = {
                                    switch step.type {
                                    case .subway: return step.subwayLine?.color ?? .gray
                                    case .bus: return step.busType?.color ?? .gray
                                    default: return .clear
                                    }
                                }()

                                ZStack {
                                    Image(.dot3)
                                }
                                
                            }
                            .frame(width: 50, alignment: .center)

                            VStack(alignment: .leading, spacing: 0) {
                                VStack(alignment: .leading, spacing: 0) {
                                    
                                    Text(step.isFinal ? "\(step.subTitle) 하차" : step.subTitle)
                                        .font(.mainTextSemibold14)
                                    

                                    Spacer().frame(height:15)

                                    HStack(spacing: 7) {
                                        if let routeDetail = step.routeDetail {
                                            Text(routeDetail)
                                                .font(.mainTextRegular12)
                                                .foregroundStyle(Color.black)
                                            
                                        }

                                        
                                        if step.destFinal != true {
                                            Rectangle()
                                                .fill(Color.gray700)
                                                .frame(width: 1, height: 10)
                                                
                                        }
                                        
                                      
                                        if let routeMeter = step.routeMeter {
                                            Text(routeMeter)
                                                .font(.mainTextRegular12)
                                        }
                                    }
                                                                    }

                                Spacer().frame(height:17)

                                if (step.type == .subway || step.type == .bus)  {
                                    Rectangle()
                                        .fill(Color.gray200)
                                        .frame(height: 1)
                                        .padding(.top, 10.0)
                                }
                            }
                        }
                        .padding(.trailing, 29.0)
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .onAppear {
            viewModel.loadMockRoutes()
            isSimpleMode = false
        }
    }
    
    // 도착일 경우 왼쪽 이모지 "fin"으로
    private func stepImage(for step: RouteStep) -> some View {
        if step.type == .walk && step.title.contains("도착") {
            return AnyView(
                Image("fin")
                    .frame(width: 18, height: 20)
            )
        }
        
        //출발일 경우 파란 핀으로 수정
        if step.title.contains("출발") {
            return AnyView(
                Image("start")
                    .frame(width: 16, height: 20)
            )
        }

        //각자 탈 것에 맞는 색깔로 표시
        let color: Color = {
            switch step.type {
            case .subway:
                return step.subwayLine?.color ?? .gray
            case .bus:
                return step.busType?.color ?? .gray
            case .walk:
                return .gray
            }
        }()
        return AnyView(
            ZStack(alignment: .center) {
                Image("check04")
                    .foregroundColor(color)
            }
                .frame(width: 16, height: 16)
        )
    }
}

    

#Preview {
    CommonStepView(step: RouteStep(type: .subway, title: "6호선", subTitle: "공덕역", detail: nil, extra: nil, Info: nil,busTime: nil,role: .subwayStop, isFinal : true, routeDetail: "공덕역 5번 출구까지", routeMeter: "도보 30m",simple: false))
}
