//
//  DynamicSlide.swift
//  UpGrade
//
//  Created by Romel Luis Faife Cruz on 2024-12-18.
//

import SwiftUI

public extension AnyTransition {
    struct DynamicSlideHorizontalModifier: ViewModifier {
        public let width: CGFloat
        @Binding public var forward: Bool

        public init(width: CGFloat, forward: Binding<Bool>) {
            self.width = width
            self._forward = forward
        }

        public func body(content: Content) -> some View {
            content
                .offset(x: (forward ? 1 : -1) * width)
        }
    }

    @MainActor static func dynamicSlideHorizontal(forward: Binding<Bool>) -> AnyTransition {
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

#Preview (traits: .controlPreview) {
    @Previewable @State var state: Bool = true
    @Previewable @State var forward: Bool = true
    
    Group {
        if state {
            ScrollView {
                ControlButton(text: "Next", type: .primary) {
                    forward = true
                    state = false
                }
            }
        } else {
            ScrollView {
                ControlButton(text: "Back", type: .primary) {
                    forward = false
                    state = true
                }
            }
        }
    }
    .transition(.dynamicSlideHorizontal(forward: $forward))
}
