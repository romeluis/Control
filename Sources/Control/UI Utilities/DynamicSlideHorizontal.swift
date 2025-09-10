//
//  DynamicSlide.swift
//  UpGrade
//
//  Created by Romel Luis Faife Cruz on 2024-12-18.
//

import SwiftUI

extension AnyTransition {
    struct DynamicSlideHorizontalModifier: ViewModifier {
        let width: CGFloat
        @Binding var forward: Bool

        func body(content: Content) -> some View {
            content
                .offset(x: (forward ? 1 : -1) * width)
        }
    }

    static func dynamicSlideHorizontal(forward: Binding<Bool>) -> AnyTransition {
        return .asymmetric(
            insertion: .modifier(
                active: DynamicSlideHorizontalModifier(width: UIScreen.main.bounds.width, forward: forward),
                identity: DynamicSlideHorizontalModifier(width: 0, forward: forward)
            ),

            removal: .modifier(
                active: DynamicSlideHorizontalModifier(width: -UIScreen.main.bounds.width, forward: forward),
                identity: DynamicSlideHorizontalModifier(width: 0, forward: forward)
            )
        )
    }
}
