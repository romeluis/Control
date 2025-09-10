//
//  DynamicSlide.swift
//  UpGrade
//
//  Created by Romel Luis Faife Cruz on 2024-12-18.
//

import SwiftUI

extension AnyTransition {
    struct DynamicSlideVerticalModifier: ViewModifier {
        let height: CGFloat
        @Binding var forward: Bool

        func body(content: Content) -> some View {
            content
                .offset(y: (forward ? -1 : 1) * height)
        }
    }

    static func dynamicSlideVertical(forward: Binding<Bool>) -> AnyTransition {
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
