//
// ControlTextField.swift
// Control
//
// Created by Romel Luis Faife Cruz on 2025-09-10.

import SwiftUI
import SwiftData

public enum ControlInputState: Equatable {
    case valid
    case invalid(message: String)
}

public struct ControlTextField: View {
    var title: String = ""
    
    @Binding var input: String
    @Binding var inputState: ControlInputState
    
    var placeholderText: String = ""
    var showError: Bool = true
    
    var backgroundColour: Color = .Control.white
    var outlineColour: Color = .clear
    var textColour: Color = .accentColor

    @Binding var validationTrigger: Bool

    var isValid: ((String) -> ControlInputState)?

    public init(
        title: String = "",
        input: Binding<String>,
        inputState: Binding<ControlInputState>,
        placeholderText: String = "",
        showError: Bool = true,
        backgroundColour: Color = .Control.white,
        outlineColour: Color = .clear,
        textColour: Color = .accentColor,
        validationTrigger: Binding<Bool> = .constant(true),
        isValid: ((String) -> ControlInputState)? = nil
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
        self.isValid = isValid
    }

    public var body: some View {
        VStack (alignment: .leading, spacing: 5) {
            
            //Title of textfield if present
            if !title.isEmpty {
                Text(title)
                    .smallText()
                    .padding(.leading, 7)
            }
            
            //Textfield
            HStack (spacing: 15) {
                TextField(placeholderText, text: $input)
                    .bodyText()
                    .padding()
                    .foregroundColor(textColour)
                    .backgroundStroke(cornerRadius: 20, colour: inputState != .valid && showError  ? .red : outlineColour)
                    .backgroundFill(cornerRadius: 20, colour: backgroundColour)
            }
            
            //Error message if input is invalid
            if case let .invalid(message) = inputState, showError {
                Text(message)
                    .smallText()
                    .padding(.leading, 7)
            }
        }
        .onChange(of: input) {
            self.updateInputs()
        }
        .onChange(of: validationTrigger) {
            self.updateInputs()
        }
    }

    func updateInputs() {
        withAnimation (.spring(duration: 0.3)) {
                if isValid != nil {
                    inputState = isValid!(input)
                } else {
                    inputState = .valid
                }
            }
    }
}

#Preview (traits: .controlPreview) {
    @Previewable @State var text1: String = ""
    @Previewable @State var text3: String = ""
    @Previewable @State var update: Bool = false
    @Previewable @State var valid1: ControlInputState = .valid
    @Previewable @State var valid3: ControlInputState = .valid
    
    VStack {
        ControlTextField(title: "Name", input: $text1, inputState: $valid1, placeholderText: "Computer Organization", validationTrigger: $update) { text in
            if text.isEmpty {
                return .invalid(message: "No empty")
            }
            return .valid
        }
        
        ControlTextField(input: $text3, inputState: $valid3, placeholderText: "Computer Organization", validationTrigger: $update) { text in
            if text.isEmpty {
                return .invalid(message: "No empty")
            } else if text == "Test" {
                return .invalid(message: "No test")
            }
            return .valid
        }
        Spacer()
        Text("Valid States: \(valid1 == .valid ? "✓" : "✗") \(valid3 == .valid ? "✓" : "✗")")
        ControlButton(text: "Update Signal", type: .primary) {
            update.toggle()
        }
    }
    .padding()
    .background(.fill)
}

