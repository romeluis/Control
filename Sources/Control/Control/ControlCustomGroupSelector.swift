//
// ControlGroupSelector.swift
// Control
//
// Created by Romel Luis Faife Cruz on 2025-09-11.

import SwiftUI
import SwiftData

public struct ControlCustomGroupSelector: View {
    var title: String = ""
    
    @Binding var input: [ControlCustomSelectorObject<AnyView>]
    var groupText: String
    
    var backgroundColour: Color = .Control.white
    var outlineColour: Color = .clear
    var symbolColour: Color = .Control.white
    var controlColour: Color = .accentColor

    public init(
        title: String = "",
        input: Binding<[ControlCustomSelectorObject<AnyView>]>,
        groupText: String,
        backgroundColour: Color = .Control.white,
        outlineColour: Color = .clear,
        symbolColour: Color = .Control.white,
        controlColour: Color = .accentColor
    ) {
        self.title = title
        self._input = input
        self.groupText = groupText
        self.backgroundColour = backgroundColour
        self.outlineColour = outlineColour
        self.symbolColour = symbolColour
        self.controlColour = controlColour
    }

    public var body: some View {
        VStack (alignment: .leading, spacing: 5) {
            //Title of selector if present
            if !title.isEmpty {
                Text(title)
                    .smallText()
                    .padding(.leading, 7)
            }
            
            VStack {
                HStack (spacing: 15) {
                    Text(groupText)
                        .bodyText()
                    Spacer()
                    
                    HStack {
                        ControlButton(text: "Select All", type: .accessory, backgroundColour: .Control.gray1, textColour: .accentColor) {
                            setAllTo(value: true)
                        }
                        ControlButton(text: "Deselect All", type: .accessory, backgroundColour: .Control.gray1, textColour: .accentColor) {
                            setAllTo(value: false)
                        }
                    }
                }
                .padding()
                .padding(.vertical, -10)
                
                ForEach(input) { element in
                    ControlCustomSelector(element)
                }
            }
            .padding()
            .backgroundFill(cornerRadius: 20, colour: backgroundColour)
        }
    }
    
    func setAllTo(value: Bool) {
        for i in 0..<input.count {
            input[i].input.wrappedValue = value
        }
    }
}

#Preview (traits: .controlPreview) {
    @Previewable @State var inner1: Bool = false
    @Previewable @State var inner2: Bool = true
    @Previewable @State var inner3: Bool = false
    @Previewable @State var inner4: Bool = false

    @Previewable @State var input: [ControlCustomSelectorObject<AnyView>] = []

    ScrollView {
        ControlCustomGroupSelector(input: $input, groupText: "Test")
            .onAppear {
                input = [
                    .init(input: $inner1) {
                        AnyView(Text("Test1"))
                    },
                    .init(input: $inner2, backgroundColour: .Control.gray1) {
                        AnyView(Text("Test2"))
                    },
                    .init(input: $inner3) {
                        AnyView(Text("Test3"))
                    }
                ]
            }
        
        ControlButton(text: "Add", type: .secondary) {
            input.append(.init(input: $inner4) {
                AnyView(Text("Test4"))
            })
        }
    }
    .padding()
    .background(.fill)
    
}
