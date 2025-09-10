//
// Callout.swift
// Control
//
// Created by Romel Luis Faife Cruz on 2025-09-10.

import SwiftUI
import SwiftData

struct Callout: View {
    var symbol: String
    var title: String
    var bodyText: String = ""
    
    var backgroundColour: Color = .Control.white
    var outlineColour: Color = .clear

    var body: some View {
        HStack (alignment: .top) {
            Symbol(symbolName: symbol, size: bodyText != "" ? 20 : 17)
                .padding(.top, bodyText != "" ? 2 : 1)
            VStack (alignment: .leading, spacing: 7) {
                Text(title)
                    .if(bodyText != "") { content in
                        content
                            .headerText()
                    }
                    .if(bodyText == "") { content in
                        content
                            .bodyText()
                    }
                if bodyText != "" {
                    Text(bodyText)
                        .bodyText()
                }
            }
            .frame(maxWidth: bodyText != "" ? .infinity : nil, alignment: bodyText != "" ? .leading : .center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .backgroundStroke(cornerRadius: 25, colour: outlineColour)
        .backgroundFill(cornerRadius: 25, colour: backgroundColour)
    }
}

#Preview (traits: .controlPreview) {
    Callout(symbol: "Warning", title: "Warning!", bodyText: "This is an important message", backgroundColour: Color("UI Light 1"))
    Callout(symbol: "Warning", title: "Warning!", backgroundColour: Color("UI Light 1"))
}