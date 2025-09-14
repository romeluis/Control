//
//  GlobalText.swift
//  Control
//
//  Created by Romel Luis Faife Cruz on 2025-09-23.
//

// In your package target (e.g., DesignSystem)

import SwiftUI
import CoreText

enum DSFontName: String, CaseIterable {
    case regular = "CreatoDisplay-Regular"
    case bold    = "CreatoDisplay-Black"
}

#if canImport(UIKit)
import UIKit
private func dsFontAvailable(_ name: String) -> Bool { UIFont(name: name, size: 12) != nil }
#elseif canImport(AppKit)
import AppKit
private func dsFontAvailable(_ name: String) -> Bool { NSFont(name: name, size: 12) != nil }
#else
private func dsFontAvailable(_ name: String) -> Bool { false }
#endif

public struct CreatoDisplay {
     public static func registerFonts() {
         DSFontName.allCases.forEach {
            registerFont(bundle: .module, fontName: $0.rawValue, fontExtension: "otf")
        }
     }

    fileprivate static func registerFont(bundle: Bundle, fontName: String, fontExtension: String) {

        guard let fontURL = bundle.url(forResource: fontName, withExtension: fontExtension) else {
            assertionFailure("Couldn't find font file \(fontName).\(fontExtension) in bundle \(bundle)")
            return
        }

        var error: Unmanaged<CFError>?

            let success = CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, &error)
            if !success {
                #if DEBUG
                if let e = error?.takeRetainedValue() {
                    print("Font registration failed for \(fontURL.lastPathComponent): \(e)")
                } else {
                    print("Font registration failed for \(fontURL.lastPathComponent) with unknown error.")
                }
                #endif
            }
    }
}

struct CustomText: ViewModifier {
    var size: CGFloat
    var bold: Bool
    var scaleFactor: CGFloat = 1.0
    var relative: Font.TextStyle

    func body(content: Content) -> some View {
        let name = bold ? DSFontName.bold : DSFontName.regular

        return content
            .font(
                dsFontAvailable(name.rawValue)
                ? .custom(name.rawValue, size: size, relativeTo: relative)
                : .system(size: size + 50, weight: bold ? .bold : .regular)
            )
            .minimumScaleFactor(scaleFactor)
            .kerning(0.1)
    }
}

public extension View {
    func customText(_ size: CGFloat,
                    bolded: Bool = false,
                    relative: Font.TextStyle) -> some View {
        modifier(CustomText(size: size, bold: bolded, scaleFactor: 1.0, relative: relative))
    }
    
    func titleText(scaleFactor: CGFloat = 1.0) -> some View {
        modifier(CustomText(size: 20, bold: false, scaleFactor: scaleFactor, relative: .largeTitle))
    }

    func bodyText(scaleFactor: CGFloat = 1.0) -> some View {
        modifier(CustomText(size: 16, bold: false, scaleFactor: scaleFactor, relative: .body))
    }

    func bodyTextBold(scaleFactor: CGFloat = 1.0) -> some View {
        modifier(CustomText(size: 16, bold: true,  scaleFactor: scaleFactor, relative: .body))
    }

    func smallText(scaleFactor: CGFloat = 1.0) -> some View {
        modifier(CustomText(size: 12, bold: false, scaleFactor: scaleFactor, relative: .caption))
    }
}
