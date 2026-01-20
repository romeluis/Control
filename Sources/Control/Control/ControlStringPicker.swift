//
//  ControlStringPicker.swift
//  Control
//
//  Created by Romel Luis Faife Cruz on 2025-09-13.
//

import SwiftUI

public struct ControlStringPicker: View {
    var title: String = ""
    
    @Binding var input: String
    @Binding var inputState: ControlInputState
    @Binding var options: [String]
    
    var initialValue: String? = nil
    var showError: Bool = true

    var backgroundColour: Color = .Control.white
    var outlineColour: Color = .clear
    var textColour: Color = .accentColor
    
    @Binding var validationTrigger: Bool
    
    var isValid: ((String) -> ControlInputState)?
    var onChange: (() -> Void)?
    
    @State private var firstChangeSignal: Bool = true

    public init(
        title: String = "",
        input: Binding<String>,
        options: Binding<[String]>,
        initialValue: String? = nil,
        backgroundColour: Color = .Control.white,
        outlineColour: Color = .clear,
        textColour: Color = .accentColor,
        validationTrigger: Binding<Bool> = .constant(true),
        isValid: ((String) -> ControlInputState)? = nil,
        onChange: (() -> Void)? = nil
    ) {
        self.title = title
        self._input = input
        self._inputState = .constant(.valid)
        self._options = options
        self.initialValue = initialValue
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
        input: Binding<String>,
        inputState: Binding<ControlInputState>,
        options: Binding<[String]>,
        initialValue: String? = nil,
        backgroundColour: Color = .Control.white,
        outlineColour: Color = .clear,
        textColour: Color = .accentColor,
        validationTrigger: Binding<Bool> = .constant(true),
        isValid: ((String) -> ControlInputState)? = nil,
        onChange: (() -> Void)? = nil
    ) {
        self.title = title
        self._input = input
        self._inputState = inputState
        self._options = options
        self.initialValue = initialValue
        self.showError = true
        self.backgroundColour = backgroundColour
        self.outlineColour = outlineColour
        self.textColour = textColour
        self._validationTrigger = validationTrigger
        self.isValid = isValid
        self.onChange = onChange
    }
    
    public var body: some View {
        VStack (alignment: .leading, spacing: 5) {
            
            if !title.isEmpty {
                Text(title)
                    .smallText()
                    .padding(.leading, 7)
            }
            
            Menu {
                //Picker logic
                Picker(selection: $input, label: EmptyView()) {
                    ForEach(options, id: \.self) { option in
                        Text(option)
                    }
                }
            } label: {
                //Picker style
                HStack {
                    Text(input)
                        .bodyText()
                        .foregroundColor(textColour)
                    Spacer()
                    Circle()
                        .fill(textColour)
                        .frame(width: 8, height: 8)
                        .padding(.trailing, 5)
                }
                .padding()
                .backgroundStroke(cornerRadius: 20, colour: inputState == .valid ? outlineColour : .red)
                .backgroundFill(cornerRadius: 20, colour: backgroundColour)
            }
            //Set initial value on appear
            .onAppear() {
                if let initial = initialValue {
                    input = initial
                } else if let first = options.first {
                    input = first
                } else {
                    input = ""
                    inputState = .invalid(message: "No options available")
                }
            }
            //Run on change function if available
            .onChange(of: input) {
                if firstChangeSignal {
                    self.firstChangeSignal = false
                    return
                }
                
                self.updateInputs()
                if onChange != nil {
                    onChange!()
                }
            }
            //Update when recieve update signal
            .onChange(of: validationTrigger) {
                self.updateInputs()
            }
            
            //Show error message
            if case let .invalid(message) = inputState, showError {
                Text(message)
                    .smallText()
                    .padding(.leading, 7)
            }
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
    @Previewable @State var text: String = ""
    @Previewable @State var textOne: String = ""
    @Previewable @State var state: ControlInputState = .valid
    @Previewable @State var stateOne: ControlInputState = .valid
    @Previewable @State var update: Bool = false
    @Previewable @State var selections: [String] = ["1", "2"]
    
    ControlStringPicker(input: $text, inputState: $stateOne, options: $selections, validationTrigger: $update) { value in
        if value == "1" {
            return .invalid(message: "Cannot be 1")
        }
        return .valid
    }
    
    ControlStringPicker(input: $textOne, inputState: $state, options: $selections, initialValue: "Select a number", validationTrigger: $update) { value in
        if selections.contains(value) == false {
            return .invalid(message: "Must select an option")
        }
        
        if value == "1" {
            return .invalid(message: "Cannot be 1")
        }
        return .valid
    }
    
    Button("Update Signal") {
        update.toggle()
    }
}
