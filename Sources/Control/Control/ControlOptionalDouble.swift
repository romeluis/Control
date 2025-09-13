//
//  ControlOptionalDouble.swift
//  Control
//
//  Created by Romel Luis Faife Cruz on 2025-09-10.
//

import SwiftUI

public struct ControlOptionalDouble: View {
    var title: String = ""
    
    @Binding var input: Double?
    @Binding var inputState: ControlInputState
    
    var placeholderText: String = "Decimal Value"
    var showError: Bool = true
    
    var backgroundColour: Color = .Control.white
    var outlineColour: Color = .clear
    var textColour: Color = .accentColor
    
    @Binding var validationTrigger: Bool
    
    @State private var currentText: String = ""
    
    public init(
        title: String = "",
        input: Binding<Double?>,
        inputState: Binding<ControlInputState>,
        placeholderText: String = "Decimal Value",
        showError: Bool = true,
        backgroundColour: Color = .Control.white,
        outlineColour: Color = .clear,
        textColour: Color = .accentColor,
        validationTrigger: Binding<Bool> = .constant(true)
    ) {
        self.title = title
        self._input = input
        self._inputState = inputState
        self.placeholderText = placeholderText
        self.showError = showError
        self.backgroundColour = backgroundColour
        self.outlineColour = outlineColour
        self.textColour = textColour
        self._validationTrigger = validationTrigger
    }
    
    public var body: some View {
        ControlTextField(title: title, input: $currentText, inputState: $inputState, placeholderText: placeholderText, showError: showError, backgroundColour: backgroundColour, outlineColour: outlineColour, textColour: textColour, validationTrigger: $validationTrigger) { value in
            if value.isEmpty {
                return .valid
            }
            
            if let _ = Double(value) {
                return .valid
            }
            return .invalid(message: "Must be a decimal value")
        }
        .keyboardType(.decimalPad)
        .onAppear {
            if let number = input {
                currentText = String(number)
            }
        }
        .onChange(of: currentText) {
            withAnimation(.spring(duration: 0.3)) {
                if let direct = Double(currentText) {
                    input = direct
                }
            }
        }
    }
}

#Preview (traits: .controlPreview) {
    @Previewable @State var text1: Double? = 0
    @Previewable @State var text3: Double? = nil
    @Previewable @State var update: Bool = false
    @Previewable @State var valid1: ControlInputState = .valid
    @Previewable @State var valid3: ControlInputState = .valid
    
    VStack {
        ControlOptionalDouble(title: "Name", input: $text1, inputState: $valid1, validationTrigger: $update)
        
        ControlOptionalDouble(input: $text3, inputState: $valid3, validationTrigger: $update)
        Spacer()
        Text("States: \(String(describing: text1)) \(String(describing: text3))")
        ControlButton(text: "Update Signal", type: .primary) {
            update.toggle()
        }
    }
    .padding()
    .background(.fill)
}
