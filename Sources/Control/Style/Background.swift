//
//  Background.swift
//  Control
//
//  Created by Romel Luis Faife Cruz on 2025-02-24.
//

import SwiftUI

struct BackgroundFill: ViewModifier {
    var cornerRadius: CGFloat
    var colour: Color
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(colour)
            )
    }
}
extension View {
    public func backgroundFill(cornerRadius: CGFloat = 25, colour: Color) -> some View {
        modifier(BackgroundFill(cornerRadius: cornerRadius, colour: colour))
    }
}

struct BackgroundStroke: ViewModifier {
    var cornerRadius: CGFloat
    var colour: Color
    
    func body(content: Content) -> some View {
        content
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(colour, lineWidth: 2)
            )
    }
}
extension View {
    public func backgroundStroke(cornerRadius: CGFloat = 25, colour: Color) -> some View {
        modifier(BackgroundStroke(cornerRadius: cornerRadius, colour: colour))
    }
}