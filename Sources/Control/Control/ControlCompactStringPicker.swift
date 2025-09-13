//
//  ControlCompactStringPicker.swift
//  Control
//
//  Created by Romel Luis Faife Cruz on 2025-09-13.
//

import SwiftUI

public struct ControlCompactStringPicker: View {
    @Binding var input: String
    var options: [String]
    
    var initialValue: String? = nil

    var backgroundColour: Color = .Control.white
    var outlineColour: Color = .clear
    var textColour: Color = .accentColor
    
    var onChange: (() -> Void)?

    public init(
        input: Binding<String>,
        options: [String],
        initialValue: String? = nil,
        backgroundColour: Color = .Control.gray1,
        outlineColour: Color = .clear,
        textColour: Color = .accentColor,
        onChange: (() -> Void)? = nil
    ) {
        self._input = input
        self.options = options
        self.initialValue = initialValue
        self.backgroundColour = backgroundColour
        self.outlineColour = outlineColour
        self.textColour = textColour
        self.onChange = onChange
    }
    
    public var body: some View {
        VStack (alignment: .leading, spacing: 5) {
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
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .backgroundStroke(cornerRadius: 10, colour: outlineColour)
                .backgroundFill(cornerRadius: 10, colour: backgroundColour)
            }
            //Set initial value on appear
            .onAppear() {
                if let initial = initialValue {
                    input = initial
                } else if let first = options.first {
                    input = first
                } else {
                    input = ""
                }
            }
            //Run on change function if available
            .onChange(of: input) {
                if onChange != nil {
                    onChange!()
                }
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
    let selections: [String] = ["1", "2"]
    
    ControlCompactStringPicker(input: $text, options: selections)
    
    ControlCompactStringPicker(input: $textOne, options: selections, initialValue: "Select a number")
}
