//
// ControlGroupSelector.swift
// Control
//
// Created by Romel Luis Faife Cruz on 2025-09-11.

import SwiftUI
import SwiftData

enum ControlGroupSelectorState {
    case selected
    case unselected
    case partiallySelected
}

struct ControlGroupSelector: View {
    var title: String = ""
    
    @Binding var input: [ControlSelectorObject<AnyView>]
    var groupText: String
    
    var enabledSymbol: String = "Check Mark"
    var partialSymbol: String = "Minus"
    var backgroundColour: Color = .Control.white
    var outlineColour: Color = .clear
    var symbolColour: Color = .Control.white
    var controlColour: Color = .accentColor

    private var groupSelector: ControlGroupSelectorState {
        let total = input.count
        let selected = input.reduce(0) { $0 + ($1.input.wrappedValue ? 1 : 0) }
        if selected == 0 || total == 0 { return .unselected }
        if selected == total { return .selected }
        return .partiallySelected
    }

    public init(
        title: String = "",
        input: Binding<[ControlSelectorObject<AnyView>]>,
        groupText: String,
        enabledSymbol: String = "Check Mark",
        partialSymbol: String = "Minus",
        backgroundColour: Color = .Control.white,
        outlineColour: Color = .clear,
        symbolColour: Color = .Control.white,
        controlColour: Color = .accentColor
    ) {
        self.title = title
        self._input = input
        self.groupText = groupText
        self.enabledSymbol = enabledSymbol
        self.partialSymbol = partialSymbol
        self.backgroundColour = backgroundColour
        self.outlineColour = outlineColour
        self.symbolColour = symbolColour
        self.controlColour = controlColour
    }

    var body: some View {
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
                    
                    Group {
                        switch groupSelector {
                        case .selected:
                            Symbol(symbol: enabledSymbol, size: 17, colour: symbolColour)
                                .background(
                                    Circle()
                                        .fill(controlColour)
                                        .frame(width: 22, height: 22)
                                )
                        case .unselected:
                            Symbol(symbol: enabledSymbol, size: 17, colour: .clear)
                                .background(
                                    Circle()
                                        .stroke(lineWidth: 2)
                                        .foregroundColor(controlColour)
                                        .frame(width: 20, height: 20)
                                )
                        case .partiallySelected:
                            Symbol(symbol: partialSymbol, size: 17, colour: symbolColour)
                                .scaleEffect(x: 0.7, y: 1.1)
                                .background(
                                    Circle()
                                        .fill(controlColour)
                                        .frame(width: 22, height: 22)
                                )
                        }
                    }
                    .id(groupSelector)
                    .padding(.trailing, 5)
                    .onTapGesture {
                        if groupSelector == .selected {
                            setAllTo(value: false)
                        } else if groupSelector == .unselected || groupSelector == .partiallySelected {
                            setAllTo(value: true)
                        }
                    }
                }
                .padding()
                .padding(.vertical, -10)
                
                ForEach(input) { element in
                    ControlSelector(element)
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

    @Previewable @State var input: [ControlSelectorObject<AnyView>] = []

    ScrollView {
        ControlGroupSelector(input: $input, groupText: "Test")
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
