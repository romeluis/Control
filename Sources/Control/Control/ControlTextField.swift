//
// ControlTextField.swift
// Control
//
// Created by Romel Luis Faife Cruz on 2025-09-10.

import SwiftUI
import SwiftData

public struct ControlTextField: View {
    var title: String = ""
    
    @Binding var input: String
    @Binding var validState: Bool
    
    var placeholderText: String = ""
    var errorMessage: String = ""
    var isPercent: Bool = false
    var showError: Bool = true
    
    var backgroundColour: Color = .Control.white
    var outlineColour: Color = .clear
    var textColour: Color = .accentColor

    @Binding var validationTrigger: Bool

    var isValid: ((String) -> Bool)?

    public init(
        title: String = "",
        input: Binding<String>,
        validState: Binding<Bool>,
        placeholderText: String = "",
        errorMessage: String = "",
        isPercent: Bool = false,
        showError: Bool = true,
        backgroundColour: Color = .Control.white,
        validationTrigger: Binding<Bool> = .constant(true),
        isValid: ((String) -> Bool)? = nil
    ) {
        self.title = title
        self._input = input
        self._validState = validState
        self.placeholderText = placeholderText
        self.errorMessage = errorMessage
        self.isPercent = isPercent
        self.showError = showError
        self.backgroundColour = backgroundColour
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
                    .if(isPercent, transform: { content in
                        content
                            .keyboardType(.numbersAndPunctuation)
                    })
                    .foregroundColor(textColour)
                    .backgroundStroke(cornerRadius: 20, colour: !validState && showError  ? .red : outlineColour)
                    .backgroundFill(cornerRadius: 20, colour: backgroundColour)
                
                //Percent symbol if it is percentage
                if isPercent {
                    Text("%")
                        //TODO: .headerText()
                        .foregroundStyle(textColour)
                }
            }
            
            //Error message if input is invalid
            if !validState && !errorMessage.isEmpty {
                Text(errorMessage)
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
                    validState = isValid!(input)
                } else {
                    validState = true
                }
            }
    }
}

#Preview (traits: .controlPreview) {
    @Previewable @State var text1: String = ""
    @Previewable @State var text2: String = ""
    @Previewable @State var text3: String = ""
    @Previewable @State var update: Bool = false
    @Previewable @State var valid1: Bool = true
    @Previewable @State var valid2: Bool = true
    @Previewable @State var valid3: Bool = true
    
    VStack {
        ControlTextField(title: "Name", input: $text1, validState: $valid1, placeholderText: "Computer Organization", errorMessage: "Name cannot be empty") { text in
            if text.isEmpty {
                return false
            }
            return true
        }
        
        ControlTextField(title: "Percent", input: $text2, validState: $valid2, placeholderText: "Number", errorMessage: "Percent must be numeric", isPercent: true, validationTrigger: $update) { text in
            do {
                _ = try sanitizeDouble(input: text)
                return true
            } catch {
                return false
            }
        }
        ControlTextField(input: $text3, validState: $valid3, placeholderText: "Computer Organization", errorMessage: "Name cannot be empty", validationTrigger: $update) { text in
            if text.isEmpty {
                return false
            }
            return true
        }
        Spacer()
        Text("Valid States: \(valid1 ? "✓" : "✗") \(valid2 ? "✓" : "✗") \(valid3 ? "✓" : "✗")")
        ControlButton(text: "Update Signal", type: .primary) {
            update.toggle()
        }
    }
    .padding()
    .background(.fill)
}

