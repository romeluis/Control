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
    
    public init(
        title: String = "",
        input: Binding<T>,
        options: [String],
        initialValue: String? = nil,
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
        options: [String],
        initialValue: String? = nil,
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
        self.showError = true
        self.backgroundColour = backgroundColour
        self.outlineColour = outlineColour
        self.textColour = textColour
        self._validationTrigger = validationTrigger
        self.isValid = isValid
        self.onChange = onChange
    }
    
    public var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
