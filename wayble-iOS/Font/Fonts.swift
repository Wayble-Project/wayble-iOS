//
//  Fonts.swift
//  wayble_iOS
//
//  Created by 신민정 on 7/9/25.
//
import SwiftUI
import Foundation

extension Font{
    enum Pretend {
        case extraBold
        case bold
        case semibold
        case medium
        case regular
        case light
        
        var value: String {
            switch self {
            case .extraBold:
                return "Pretendard-ExtraBold"
            case .bold:
                return "Pretendard-Bold"
            case .semibold:
                return "Pretendard-SemiBold"
            case .medium:
                return "Pretendard-Medium"
            case .regular:
                return "Pretendard-Regular"
            case .light:
                return "Pretendard-Light"
            }
        }
    }
    
    static func pretend(type: Pretend, size: CGFloat) -> Font {
        return .custom(type.value, size: size)
    }
    static var mainTextBold20: Font  {
        return .pretend(type: .bold, size: 20)
    }
    static var mainTextBold24: Font {
        return .pretend(type: .bold, size: 24)
    }
    static var mainTextSemibold24: Font {
        return .pretend(type: .semibold, size: 24)
    }
    static var mainTextSemiBold18: Font {
        return .pretend(type: .semibold, size: 18)
    }
    static var mainTextSemibold16: Font {
        return .pretend(type: .semibold, size: 16)
    }
    static var mainTextSemiBold14: Font {
        return .pretend(type: .semibold, size: 14)
    }
    static var mainTextMedium16: Font {
        return .pretend(type: .medium, size: 16)
    }
    static var mainTextRegular18: Font {
        return .pretend(type: .regular, size: 18)
    }
    static var mainTextRegular13: Font {
        return .pretend(type: .regular, size: 13)
    }
    static var mainTextRegular12: Font {
        return .pretend(type: .regular, size: 12)
    }
    static var mainTextRegular09: Font {
        return .pretend(type: .regular, size: 9)
    }
    static var mainTextLight14: Font {
        return .pretend(type: .light, size: 14)
    }
    static var mainTextExtraBold24: Font {
        return .pretend(type: .extraBold, size: 24)
    }
    static var mainTextSemiBold38: Font {
        return .pretend(type: .semibold, size: 38)
    }
    static var mainTextSemiBold13: Font {
        return .pretend(type: .semibold, size: 13)
    }
    static var makeMedium18: Font {
        return .pretend(type: .medium, size: 18)
    }
    static var mainTextLight24: Font {
        return .pretend(type: .light, size: 24)
    }
    static var mainTextBold15: Font {
        return .pretend(type: .bold, size: 15)
    }
    static var mainTextSemibold22: Font {
        return .pretend(type: .semibold, size: 22)
    }
    static var mainTextSemibold14: Font {
        return .pretend(type: .semibold, size: 14)
    }
    
    static var mainTextMedium10: Font {
        return .pretend(type: .medium, size: 10)
    }
    static var mainTextMedium12: Font {
        return .pretend(type: .medium, size: 12)
    }
    
    static var mainTextSemibold18: Font {
        return .pretend(type: .semibold, size: 18)
    }

    static var mainTextSemibold20: Font {
        return .pretend(type: .semibold, size: 20)
    }
    static var mainTextRegular14: Font {
        return .pretend(type: .regular, size: 14)
    }
        
    static var mainTextRegular16: Font {
        return .pretend(type: .regular, size: 16)
    }
    
    static var mainTextRegular24: Font {
        return .pretend(type: .regular, size: 24)
    }
    
    static var mainTextRegular20: Font {
        return .pretend(type: .regular, size: 20)
    }
    
    static var mainTextRegular10: Font {
        return .pretend(type: .regular, size: 10)
    }
        
    static var mainTextSemibold12: Font {
        return .pretend(type: .semibold, size: 12)
    }
    
    static var mainTextSemibold10: Font {
        return .pretend(type: .semibold, size: 10)
    }

}
