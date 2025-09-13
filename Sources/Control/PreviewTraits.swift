//
//  PreviewTraits.swift
//  Control
//
//  Created by Romel Luis Faife Cruz on 2025-09-10.
//
import SwiftUI

public struct ControlPreview: PreviewModifier {
    // Runs once per preview process
    public static func makeSharedContext() async throws {
        CreatoDisplay.registerFonts()
    }
    public func body(content: Content, context: Void) -> some View { content }
}


public extension PreviewTrait where T == Preview.ViewTraits {
    @MainActor static var controlPreview: Self = .modifier(ControlPreview())
}
