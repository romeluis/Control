//
// ControlToggle.swift
// Control
//
// Created by Romel Luis Faife Cruz on 2025-09-08.

import SwiftUI

public struct ControlToggle: View {
    var title: String = ""
    @Binding var input: Bool

    var activatedText: String = "On"
    var deactivatedText: String = "Off"
    var textColour: Color = .accentColor
    var containerColour: Color = .Control.white
    var outlineColour: Color = .clear

    public init(
        title: String = "",
        input: Binding<Bool>,
        activatedText: String = "On",
        deactivatedText: String = "Off",
        textColour: Color = .accentColor,
        containerColour: Color = .Control.white,
        outlineColour: Color = .clear
    ) {
        self.title = title
        self._input = input
        self.activatedText = activatedText
        self.deactivatedText = deactivatedText
        self.textColour = textColour
        self.containerColour = containerColour
        self.outlineColour = outlineColour
    }
    
    public var body: some View {
        VStack (alignment: .leading, spacing: 5) {

            //Title only if it is not empty
            if !title.isEmpty {
                Text(title)
                    .smallText()
                    .padding(.leading, 7)
            }

            HStack {
                //On/off text
                Text(input ? activatedText : deactivatedText)
                    .bodyText()
                    .foregroundColor(textColour)
                    .id(input)
                    .transition(.blurReplace)
                    
                Spacer()

                //Toggle
                Toggle("", isOn: $input)
                    .labelsHidden()
                    .tint(.accentColor)
                    .padding(.vertical, -4)
            }
            .padding()
            .backgroundStroke(cornerRadius: 20, colour: outlineColour)
            .backgroundFill(cornerRadius: 20, colour: containerColour)
            .animation(.spring(duration: 0.5), value: input)
        }
    }
}

#Preview (traits: .controlPreview) {
    @Previewable @State var toggle: Bool = true
    
    ScrollView {
        VStack {
            ControlToggle(title: "Hello", input: $toggle)
            ControlToggle(title: "Hello", input: $toggle, activatedText: "Long", deactivatedText: "Looooooooonger")
        }
        .padding(.horizontal)
    }
    .background(.fill)
}
