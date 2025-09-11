//
//  ControlSelector.swift
//  Control
//
//  Created by Romel Luis Faife Cruz on 2025-09-11.
//

import SwiftUI

@Observable
public final class ControlSelectorObject<Content: View>: Identifiable {
    public var title: String
    public var input: Binding<Bool>

    public var symbol: String = "Check Mark"
    public var backgroundColour: Color = .Control.white
    public var outlineColour: Color = .clear
    public var symbolColour: Color = .Control.white
    public var controlColour: Color = .accentColor
    
    public var content: Content

    public init(
        title: String = "",
        input: Binding<Bool>,
        symbol: String = "Check Mark",
        backgroundColour: Color = .Control.white,
        outlineColour: Color = .clear,
        symbolColour: Color = .Control.white,
        controlColour: Color = .accentColor,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.input = input
        self.symbol = symbol
        self.backgroundColour = backgroundColour
        self.outlineColour = outlineColour
        self.symbolColour = symbolColour
        self.controlColour = controlColour
        self.content = content()
    }
}

public struct ControlSelector<Content: View>: View {
    @Bindable var object: ControlSelectorObject<Content>
    
    @Binding var internalState: Bool
    
    public init(
        title: String = "",
        input: Binding<Bool>,
        symbol: String = "Check Mark",
        backgroundColour: Color = .Control.white,
        outlineColour: Color = .clear,
        symbolColour: Color = .Control.white,
        controlColour: Color = .accentColor,
        @ViewBuilder content: () -> Content
    ) {
        self._object = .init(wrappedValue:
            ControlSelectorObject(
                title: title,
                input: input,
                symbol: symbol,
                backgroundColour: backgroundColour,
                outlineColour: outlineColour,
                symbolColour: symbolColour,
                controlColour: controlColour,
                content: content
            )
        )
        self._internalState = input
    }
    public init(_ object: ControlSelectorObject<Content>) {
        self._object = .init(wrappedValue: object)
        self._internalState = object.input
    }

    public var body: some View {
        VStack (alignment: .leading, spacing: 5) {
            //Title of selector if present
            if !object.title.isEmpty {
                Text(object.title)
                    .smallText()
                    .padding(.leading, 7)
            }
            
            HStack (spacing: 15) {
                object.content
                Spacer()
                
                Group {
                    if internalState {
                        Symbol(symbol: object.symbol, size: 17, colour: object.symbolColour)
                            .background(
                                Circle()
                                    .fill(object.controlColour)
                                    .frame(width: 22, height: 22)
                            )
                    } else {
                        Symbol(symbol: object.symbol, size: 17, colour: .clear)
                            .background(
                                Circle()
                                    .stroke(lineWidth: 2)
                                    .foregroundColor(object.controlColour)
                                    .frame(width: 20, height: 20)
                            )
                    }
                }
                .padding(.trailing, 5)
            }
            .padding()
            .backgroundStroke(cornerRadius: 20, colour: object.outlineColour)
            .backgroundFill(cornerRadius: 20, colour: object.backgroundColour)
            .onTapGesture {
                withAnimation(.spring(duration: 0.1)) {
                    internalState.toggle()
                }
            }
        }
    }
}

#Preview (traits: .controlPreview) {
    @Previewable @State var input: Bool = false
    @Previewable @State var input1: Bool = true
    @Previewable @State var selectors: [ControlSelectorObject<Text>] = []
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
        
        HorizontalDivider(colour: .Control.gray4)
        
        ForEach(selectors) { selector in
            ControlSelector(selector)
        }
        
        ControlButton(text: "Add", type: .secondary) {
            let new = ControlSelectorObject(title: "Dynamic \(selectors.count + 1)", input: $input1, content: {
                Text("This is dynamic \(selectors.count + 1)!")
            })
            selectors.append(new)
        }
    }
    .padding()
    .background(.fill)
}
