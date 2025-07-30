//
//  HomeView.swift
//  wayble_iOS
//
//  Created by 신민정 on 7/9/25.
//

import SwiftUI
import Foundation
import Observation
import AVKit


struct HomeView: View {
    @Binding var selectedIndex: Int
    @Environment(NavigationRouter.self) private var router
    @Bindable var viewModel = OnboardingViewModel()
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                Image(.waybleLogo3)
                Text("wayble")
                    .font(.mainTextSemibold20)
            }
            .padding(.leading,10)
            Spacer()
                .frame(height:21)
            ZStack(alignment: .top) {
                GeometryReader { geo in
                    MP4View(filename: "Home", fileExtension: "mp4", size: geo.size)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                    
                }
                .frame(width: 350, height: 343)
                
                VStack(alignment: .leading,spacing: 0) {
                    
                    VStack(alignment: .leading,spacing: 0) {
                        VStack(alignment: .leading,spacing: 0) {
                            
                            Spacer()
                                .frame(height:19)
                            
                            Text("\(viewModel.userInfo.nickname)님, 안녕하세요")
                                .font(.mainTextSemibold16)
                            
                            Spacer()
                                .frame(height:9)
                            
                            (
                                Text("오늘은 ")
                                    .font(.mainTextSemibold24) +
                                Text("아임히어") //여기 웨이블존 모델 카페 이름으로 다시
                                    .font(.mainTextSemibold24)
                                    .foregroundStyle(Color("blue-700")) +
                                Text("를 추천해요")
                                    .font(.mainTextSemibold24)
                            )
                        }
                        .padding(.horizontal,30)
                        
                        Spacer()
                            .frame(height:6)
                        
                        // 아이콘 웨이블존 껄로 다시
                        HStack(spacing: 0) {
                            ForEach(0..<5) { _ in
                                VStack(spacing: 5.6) {
                                    Image("chair01") // 임시 아이콘
                                        .frame(width: 23, height: 23)
                                    Text("경사로")
                                        .font(.mainTextSemibold11)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            
                        }
                        
                        
                    }
                    
                    
                    Spacer()
                        .frame(height:154)
                    
                    HStack() {
                        Button(action: {
                            withAnimation(.default){
                                selectedIndex = 3
                            }
                        }) {
                            HStack(spacing: 0) {
                                Text("길찾기")
                                    .font(.mainTextSemibold14)
                                    .foregroundStyle(Color.white)
                                    .fixedSize()
                                
                                Image("right")
                            }
                            .frame(width: 55, height: 20)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color("blue-700"))
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .buttonStyle(.plain)
                   
                    }
                    .padding(.leading, 20)
                    
                    Spacer()
                        .frame(height: 59)

                    HStack(spacing: 10) {
                        Button(action: {withAnimation(.default){
                            selectedIndex = 4
                        }
                        }) {
                            VStack(alignment:.leading, spacing: 6) {
                                Text("웨이블존")
                                    .font(.mainTextSemibold16)
                                Text("우리 주변 접근성 정보를 보여드려요")
                                    .font(.mainTextRegular14)
                                    .foregroundStyle(Color.gray700)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Spacer()
                                HStack {
                                    Spacer()
                                    Image("home1")
                                }
                            }
                            .padding(.all, 20.0)
                            .frame(width: 170, height: 210)
                            .background(Color.white)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.gray300, lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                        
                        Button(action : {
                            withAnimation(.default)
                            {
                                selectedIndex = 3 // 탭 인덱스를 이동
                            }
                            
                        }) {
                            VStack(alignment:.leading, spacing: 6)  {
                                
                                Text("길찾기")
                                    .font(.mainTextSemibold16)
                                Text("개인에 맞춘 최적 경로를 추천해요")
                                    .font(.mainTextRegular14)
                                    .foregroundStyle(Color.gray700)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                Spacer()
                                HStack {
                                    Spacer()
                                    Image("home2")
                                }
                            }
                            .padding(20)
                            .frame(width: 170, height: 210)
                            .background(Color.white)
                            .cornerRadius(15)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.gray300, lineWidth: 1)
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer()
                }
            }
            .padding(.horizontal,10)
        }
        .padding(.horizontal,20)
        .padding(.top, 12)
    }
      
}

#Preview {
    HomeView(selectedIndex: .constant(0))
        .withRouter(selectedIndex: .constant(0))
}
