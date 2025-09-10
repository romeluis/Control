//
//  GlobalText.swift
//  Control
//
//  Created by Romel Luis Faife Cruz on 2025-09-23.
//

import SwiftUI

public struct CreatoDisplay {
    
}

struct CustomText: ViewModifier {
    var size: CGFloat
    var bold: Bool
    var scaleFactor: CGFloat = 1.0
    var relative: Font.TextStyle
    
    
    func body(content: Content) -> some View {
        content
            .font(Font.custom(bold ? "CreatoDisplay-Black" : "CreatoDisplay-Regular", size: size, relativeTo: relative))
            .minimumScaleFactor(scaleFactor)
            .kerning(0.1)
    }
}
extension View {
    func customText(_ size: CGFloat, bolded: Bool = false, relative: Font.TextStyle) -> some View {
        modifier(CustomText(size: size, bold: bolded, relative: relative))
    }
}

extension View {
    public func bodyText(scaleFactor: CGFloat = 1.0) -> some View {
        modifier(CustomText(size: 16, bold: false, scaleFactor: scaleFactor, relative: .body))
    }
}

extension View {
    public func smallText(scaleFactor: CGFloat = 1.0) -> some View {
        modifier(CustomText(size: 12, bold: false, scaleFactor: scaleFactor, relative: .caption))
    }
}
