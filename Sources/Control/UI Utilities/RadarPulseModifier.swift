//
//  RadarPulseModifier.swift
//  Control
//
//  Created by Romel Luis Faife Cruz on 2025-10-03.
//

import SwiftUI

public struct RadarPulseModifier: ViewModifier {
    @Binding var isActive: Bool
    let color: Color
    let duration: Double
    let startScale: CGFloat
    let endScale: CGFloat
    let startOpacity: Double
    let endOpacity: Double

    @State private var scale: CGFloat
    @State private var opacity: Double

    public init(isActive: Binding<Bool>, color: Color, duration: Double = 2.0, startScale: CGFloat = 1.0, endScale: CGFloat = 2.5, startOpacity: Double = 0.8, endOpacity: Double = 0.0) {
        self._isActive = isActive
        self.color = color
        self.duration = duration
        self.startScale = startScale
        self.endScale = endScale
        self.startOpacity = startOpacity
        self.endOpacity = endOpacity
        self._scale = State(initialValue: startScale)
        self._opacity = State(initialValue: startOpacity)
    }

    public func body(content: Content) -> some View {
        content
            .overlay {
                if isActive {
                    content
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .foregroundStyle(color)
                        .onAppear {
                            withAnimation(.easeOut(duration: duration).repeatForever(autoreverses: false)) {
                                scale = endScale
                                opacity = endOpacity
                            }
                        }
                        .onChange(of: isActive) { _, newValue in
                            if newValue {
                                scale = startScale
                                opacity = startOpacity
                                withAnimation(.easeOut(duration: duration).repeatForever(autoreverses: false)) {
                                    scale = endScale
                                    opacity = endOpacity
                                }
                            }
                        }
                }
            }
    }
}

extension View {
    public func radarPulse(isActive: Binding<Bool>, color: Color, duration: Double = 2.0, startScale: CGFloat = 1.0, endScale: CGFloat = 2.5, startOpacity: Double = 0.8, endOpacity: Double = 0.0) -> some View {
        self.modifier(RadarPulseModifier(isActive: isActive, color: color, duration: duration, startScale: startScale, endScale: endScale, startOpacity: startOpacity, endOpacity: endOpacity))
    }
}
