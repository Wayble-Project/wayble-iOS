//
//  GIFImageViewRepresentable.swift
//  wayble-iOS
//
//  Created by 신민정 on 7/24/25.
//

//gif 처리

import SwiftUI
import Gifu

struct GIFImageViewRepresentable: UIViewRepresentable {
    let gifName: String

    func makeUIView(context: Context) -> GIFImageView {
        let imageView = GIFImageView()
        imageView.animate(withGIFNamed: gifName)
        return imageView
    }

    func updateUIView(_ uiView: GIFImageView, context: Context) {
       
    }
}

//프리뷰에서 gif 보기 
struct SafeGIFView: View {
    let gifName: String

    var body: some View {
        if ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1" {
            Image(gifName) // 똑같은 이름의 png 도 저장하기!! 
                .resizable()
                .scaledToFit()
        } else {
            GIFImageViewRepresentable(gifName: gifName)
        }
    }
}
