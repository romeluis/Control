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
    var containerColour: Color = Color("UI White")
    var outlineColour: Color = .clear
    
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
                    .transition(.opacity)
                    
                Spacer()

                //Toggle
                Toggle("", isOn: $input)
                    .labelsHidden()
                    .tint(.accentColor)
                    .padding(.vertical, -4)
            }
            .padding()
            .backgroundFill(cornerRadius: 20, colour: containerColour)
            .backgroundStroke(cornerRadius: 20, colour: outlineColour)
            .animation(.spring(duration: 0.3), value: input)
        }
    }
}

#Preview {
    @Previewable @State var toggle: Bool = true
    
    ControlToggle(title: "Hello", input: $toggle)
}
