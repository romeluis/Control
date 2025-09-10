//
//  PreviewTraits.swift
//  Control
//
//  Created by Romel Luis Faife Cruz on 2025-09-10.
//
import SwiftUI

struct ControlPreview: PreviewModifier {
    // Runs once per preview process
    static func makeSharedContext() async throws {
        CreatoDisplay.registerFonts()
    }
    func body(content: Content, context: Void) -> some View { content }
}


extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var controlPreview: Self = .modifier(ControlPreview())
}
