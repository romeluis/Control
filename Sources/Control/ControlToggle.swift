//
// ControlToggle.swift
// Control
//
// Created by Romel Luis Faife Cruz on 2025-09-08.

import SwiftUI

public struct ControlToggle: View {
    public var title: String = ""
    @Binding public var input: Bool

    public var activatedText: String = "On"
    public var deactivatedText: String = "Off"
    public var textColour: Color = .accentColor
    public var containerColour: Color = .white
    public var outlineColour: Color = .clear
    
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
            .backgroundFill(cornerRadius: 20, colour: containerColour)
            .backgroundStroke(cornerRadius: 20, colour: outlineColour)
            .animation(.spring(duration: 0.5), value: input)
        }
    }
}

#Preview {
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
