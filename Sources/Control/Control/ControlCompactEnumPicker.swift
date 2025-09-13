//
//  ControlCompactEnumPicker.swift
//  Control
//
//  Created by Romel Luis Faife Cruz on 2025-09-13.
//

import SwiftUI

public struct ControlCompactEnumPicker<T>: View where T: RawRepresentable & CaseIterable & Hashable, T.RawValue == String {
    @Binding var input: T
    
    var suffix: String = ""
    
    var backgroundColour: Color = .Control.white
    var outlineColour: Color = .clear
    var textColour: Color = .accentColor
    
    var onChange: (() -> Void)?
    
    @State private var internalString: String = ""
    
    private var options: [String] {
        var ret: [String] = []
        for item in T.allCases {
            ret.append(item.rawValue + suffix)
        }
        return ret
    }
    
    public init(
        input: Binding<T>,
        suffix: String = "",
        backgroundColour: Color = .Control.white,
        outlineColour: Color = .clear,
        textColour: Color = .accentColor,
        onChange: (() -> Void)? = nil
    ) {
        self._input = input
        self.suffix = suffix
        self.backgroundColour = backgroundColour
        self.outlineColour = outlineColour
        self.textColour = textColour
        self.onChange = onChange
    }
    
    public var body: some View {
        Group {
            ControlCompactStringPicker(input: $internalString, options: options, initialValue: input.rawValue + suffix, backgroundColour: backgroundColour, outlineColour: outlineColour, textColour: textColour, onChange: onChange)
        }
        .onChange(of: internalString) {
            let stripped: String = stripSuffix(internalString, suffix: suffix)
            if let converted: T = T.allCases.first(where: { $0.rawValue == stripped }) {
                input = converted
            }
        }
        .onChange(of: input) {
            internalString = input.rawValue + suffix
        }
    }
    
    func stripSuffix(_ string: String, suffix: String) -> String {
        guard string.hasSuffix(suffix) else { return string }
        let range = string.index(string.endIndex, offsetBy: -suffix.count)..<string.endIndex
        return String(string[..<range.lowerBound])
    }
}

private enum TestEnum: String, CaseIterable, Hashable {
    case one = "One"
    case two = "Two"
    case three = "Three"
    case four = "Four"
}

#Preview (traits: .controlPreview) {
    
    
    @Previewable @State var testEnum: TestEnum = .three
    @Previewable @State var testEnum2: TestEnum = .one
    @Previewable @State var update: Bool = false
    @Previewable @State var state: ControlInputState = .valid
    
    ScrollView {
        ControlCompactEnumPicker(input: $testEnum2, suffix: " minute")
        Text(testEnum.rawValue)
        Text(testEnum2.rawValue)
        ControlButton(symbol: "Refresh", type: .primary) {
            update.toggle()
        }
    }
    .background(.fill)
}
