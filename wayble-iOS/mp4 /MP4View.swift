//
//  MP4View.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/29/25.
//
/*
 사용할 파일이 Search 라고 했을 때! 사용할 파일에 다음과 같은 방법으로 사용해주세요!!
 .frame , .padding, .clipped() 은 자유롭게 조절 가능
 GeometryReader { geo in
     MP4View(filename: "Search", fileExtension: "mp4", size: geo.size)
         .frame(height: 479)
         .padding(.bottom, 54)
         .clipped()
 }
 .frame(height: 479) 한번 더 .frame 적기!! */


import SwiftUI
import AVFoundation

struct MP4View: UIViewRepresentable {
    let filename: String
    let fileExtension: String
    let size: CGSize
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        
        guard let url = Bundle.main.url(forResource: filename, withExtension: fileExtension) else {
            return view
        }
        
        let player = AVPlayer(url: url)
        let playerLayer = AVPlayerLayer(player: player)
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.needsDisplayOnBoundsChange = true
        playerLayer.masksToBounds = true
        view.layer.addSublayer(playerLayer)
        
        player.play()
        
    
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { _ in
            player.seek(to: .zero)
            player.play()
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        if let playerLayer = uiView.layer.sublayers?.first(where: { $0 is AVPlayerLayer }) as? AVPlayerLayer {
            playerLayer.frame = CGRect(origin: .zero, size: size)
        }
    }
}
