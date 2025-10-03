//
//  AnimatableRotationModifier.swift
//  Control
//
//  Created by Romel Luis Faife Cruz on 2025-10-03.
//

import SwiftUI

@MainActor
public struct AnimatableRotationModifier: ViewModifier, @MainActor Animatable {
    public var angle: Double

    public var animatableData: Double {
        get { angle }
        set { angle = newValue }
    }

    public func body(content: Content) -> some View {
        content.rotationEffect(Angle(radians: angle))
    }
}

extension View {
    public func animatableRotation(_ angle: Double) -> some View {
        self.modifier(AnimatableRotationModifier(angle: angle))
    }
}

