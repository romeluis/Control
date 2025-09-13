//
//  ControlEnumPicker.swift
//  Control
//
//  Created by Romel Luis Faife Cruz on 2025-09-13.
//

import SwiftUI

public struct ControlEnumPicker<T>: View where T: RawRepresentable & CaseIterable & Hashable, T.RawValue == String {
    var title: String = ""
    
    @Binding var input: T
    @Binding var inputState: ControlInputState
    
    var suffix: String = ""
    var showError: Bool = false
    
    var backgroundColour: Color = .Control.white
    var outlineColour: Color = .clear
    var textColour: Color = .accentColor
    
    @Binding var validationTrigger: Bool
    
    var isValid: ((T) -> ControlInputState)?
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
        title: String = "",
        input: Binding<T>,
        suffix: String = "",
        backgroundColour: Color = .Control.white,
        outlineColour: Color = .clear,
        textColour: Color = .accentColor,
        validationTrigger: Binding<Bool> = .constant(true),
        isValid: ((T) -> ControlInputState)? = nil,
        onChange: (() -> Void)? = nil
    ) {
        self.title = title
        self._input = input
        self._inputState = .constant(.valid)
        self.suffix = suffix
        self.showError = false
        self.backgroundColour = backgroundColour
        self.outlineColour = outlineColour
        self.textColour = textColour
        self._validationTrigger = validationTrigger
        self.isValid = isValid
        self.onChange = onChange
    }
    public init(
        title: String = "",
        input: Binding<T>,
        inputState: Binding<ControlInputState>,
        suffix: String = "",
        backgroundColour: Color = .Control.white,
        outlineColour: Color = .clear,
        textColour: Color = .accentColor,
        validationTrigger: Binding<Bool> = .constant(true),
        isValid: ((T) -> ControlInputState)? = nil,
        onChange: (() -> Void)? = nil
    ) {
        self.title = title
        self._input = input
        self._inputState = inputState
        self.suffix = suffix
        self.showError = true
        self.backgroundColour = backgroundColour
        self.outlineColour = outlineColour
        self.textColour = textColour
        self._validationTrigger = validationTrigger
        self.isValid = isValid
        self.onChange = onChange
    }
    
    public var body: some View {
        Group {
            if showError {
                ControlStringPicker(title: title, input: $internalString, inputState: $inputState, options: options, initialValue: input.rawValue + suffix, backgroundColour: backgroundColour, outlineColour: outlineColour, textColour: textColour, validationTrigger: $validationTrigger) { value in
                    if isValid != nil {
                        let stripped: String = stripSuffix(value, suffix: suffix)
                        if let converted: T = T.allCases.first(where: { $0.rawValue == stripped }) {
                            return isValid!(converted)
                        } else {
                            return .invalid(message: "Unable to match value to enum")
                        }
                    } else {
                        return .valid
                    }
                } onChange: {
                    if onChange != nil {
                        onChange!()
                    }
                }
            } else {
                ControlStringPicker(title: title, input: $internalString, options: options, initialValue: input.rawValue + suffix, backgroundColour: backgroundColour, outlineColour: outlineColour, textColour: textColour, onChange: onChange)
            }
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
        ControlEnumPicker(input: $testEnum, inputState: $state, validationTrigger: $update) { value in
            if value == .three {
                return .invalid(message: "Cannot be 3")
            }
            return .valid
        }
        ControlEnumPicker(input: $testEnum2, suffix: " minute")
        Text(testEnum.rawValue)
        Text(testEnum2.rawValue)
        ControlButton(symbol: "Refresh", type: .primary) {
            update.toggle()
        }
    }
    .background(.fill)
}
