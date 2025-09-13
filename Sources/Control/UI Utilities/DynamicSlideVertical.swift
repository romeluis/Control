//
//  DynamicSlide.swift
//  UpGrade
//
//  Created by Romel Luis Faife Cruz on 2024-12-18.
//

import SwiftUI

public extension AnyTransition {
    struct DynamicSlideVerticalModifier: ViewModifier {
        let height: CGFloat
        @Binding var forward: Bool
        
        public init(height: CGFloat, forward: Binding<Bool>) {
            self.height = height
            self._forward = forward
        }

        public func body(content: Content) -> some View {
            content
                .offset(y: (forward ? -1 : 1) * height)
        }
    }

    @MainActor static func dynamicSlideVertical(forward: Binding<Bool>) -> AnyTransition {
        return .asymmetric(
            insertion: .modifier(
                active: DynamicSlideVerticalModifier(height: 30, forward: forward),
                identity: DynamicSlideVerticalModifier(height: 0, forward: forward)
            ).combined(with: .opacity).combined(with: .opacity),

            removal: .modifier(
                active: DynamicSlideVerticalModifier(height: -30, forward: forward),
                identity: DynamicSlideVerticalModifier(height: 0, forward: forward)
            ).combined(with: .opacity).combined(with: .scale)
        )
    }
}
