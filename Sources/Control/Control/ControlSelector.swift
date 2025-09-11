//
//  ControlSelector.swift
//  Control
//
//  Created by Romel Luis Faife Cruz on 2025-09-11.
//

import SwiftUI

public struct ControlSelector<Content: View>: View {
    var title = ""
    
    @Binding var input: Bool
    
    var symbol: String = "Check Mark"
    var backgroundColour: Color = .Control.white
    var outlineColour: Color = .clear
    var symbolColour: Color = .Control.white
    var controlColour: Color = .accentColor
    
    @ViewBuilder var content: Content
    
    public var body: some View {
        VStack (alignment: .leading, spacing: 5) {
            //Title of selector if present
            if !title.isEmpty {
                Text(title)
                    .smallText()
                    .padding(.leading, 7)
            }
            
            HStack (spacing: 15) {
                content
                Spacer()
                
                Group {
                    if input {
                        Symbol(symbol: symbol, size: 17, colour: symbolColour)
                            .background(
                                Circle()
                                    .fill(controlColour)
                                    .frame(width: 22, height: 22)
                            )
                    } else {
                        Symbol(symbol: symbol, size: 17, colour: .clear)
                            .background(
                                Circle()
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(controlColour)
                                    .frame(width: 20, height: 20)
                            )
                    }
                }
                .padding(.trailing, 5)
            }
            .padding()
            .backgroundStroke(cornerRadius: 20, colour: outlineColour)
            .backgroundFill(cornerRadius: 20, colour: backgroundColour)
            .onTapGesture {
                withAnimation(.spring(duration: 0.1)) {
                    input.toggle()
                }
            }
        }
    }
}

#Preview (traits: .controlPreview) {
    @Previewable @State var input: Bool = false
    ScrollView {
        ControlSelector(title: "Test", input: $input) {
            Text("Test")
                .bodyText()
        }
        ControlSelector(title: "Test", input: $input, symbol: "Cancel") {
            VStack {
                Symbol(symbol: "Check Mark", size: 17, colour: .blue)
                Text("Anything can go here!")
            }
        }
    }
    .padding()
    .background(.fill)
}
