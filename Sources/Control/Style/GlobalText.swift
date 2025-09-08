//
//  GlobalText.swift
//  Control
//
//  Created by Romel Luis Faife Cruz on 2025-01-23.
//

import SwiftUI

struct CustomText: ViewModifier {
    var size: CGFloat
    var bold: Bool
    var scaleFactor: CGFloat = 1.0
    var relative: Font.TextStyle
    
    
    func body(content: Content) -> some View {
        content
            .font(bold ? .system(size: size, weight: .black, design: .default).width(.standard) : 
                        .system(size: size, weight: .regular, design: .default).width(.standard))
            .minimumScaleFactor(scaleFactor)
            .kerning(0.1)
    }
}
extension View {
    public func customText(_ size: CGFloat, bolded: Bool = false, relative: Font.TextStyle) -> some View {
        modifier(CustomText(size: size, bold: bolded, relative: relative))
    }
}


extension View {
    public func largeText(scaleFactor: CGFloat = 1.0) -> some View {
        modifier(CustomText(size: 37, bold: true, scaleFactor: scaleFactor, relative: .callout))
    }
}

extension View {
    public func focusText(scaleFactor: CGFloat = 1.0) -> some View {
        modifier(CustomText(size: 25, bold: false, scaleFactor: scaleFactor, relative: .subheadline))
    }
}

extension View {
    public func importantText(scaleFactor: CGFloat = 1.0) -> some View {
        modifier(CustomText(size: 20, bold: true, scaleFactor: scaleFactor, relative: .subheadline))
    }
}


extension View {
    public func headerText(scaleFactor: CGFloat = 1.0) -> some View {
        modifier(CustomText(size: 20, bold: false, scaleFactor: scaleFactor, relative: .title))
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