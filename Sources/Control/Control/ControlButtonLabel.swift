//
//  ControlButtonLabel.swift
//  UpGrade
//
//  Created by Romel Luis Faife Cruz on 2025-08-06.
//

import SwiftUI

struct ControlButtonLabel: View {
    @Environment(\.isEnabled) var isEnabled
    
    var text: String?
    var symbol: String?
    
    var type: ControlButtonType
    var symbolLocation: ControlButtonSymbolLocation = .leading
    var buttonLocation: Alignment = .center
    var expandWidth: Bool = false
    
    var backgroundColour: Color? = nil
    var outlineColour: Color? = nil
    var textColour: Color? = nil
    
    var backgroundColourCalculated: Color {
        if let colour = backgroundColour {
            return colour
        }
        
        switch type {
        case .primary:
            return .accentColor
        case .secondary:
            return .Control.gray1
        case .accessory:
            return .clear
        case .mini:
            return .clear
        case .capsule:
            return .Control.white
        case .toolbar:
            return .clear
        }
    }
    var outlineColourCalculated: Color {
        if let colour = outlineColour {
            return colour
        }
        return .clear
    }
    var textColourCalculated: Color {
        if let colour = textColour {
            return colour
        }
        
        switch type {
        case .primary:
            return .Control.white
        case .secondary:
            return .Control.black
        case .accessory:
            return .Control.black
        case .mini:
            return .Control.black
        case .capsule:
            return .Control.black
        case .toolbar:
            return .Control.black
        }
    }
    
    private var symbolSize: CGFloat {
        switch type {
        case .primary:
            return 20
        case .secondary:
            return 20
        case .toolbar:
            return 22
        case .accessory:
            return 15
        case .capsule:
            return 20
        case .mini:
            return 10
        }
    }
    
    private var cornerRadius: CGFloat {
        switch type {
        case .primary:
            return 20
        case .secondary:
            return 20
        case .toolbar:
            return 100
        case .accessory:
            return 10
        case .capsule:
            return 100
        case .mini:
            return 10
        }
    }
    
    private var horizontalPadding: CGFloat {
        switch type {
        case .primary:
            return text == nil ? 14 : 20
        case .secondary:
            return text == nil ? 14 : 20
        case .toolbar:
            return 10
        case .accessory:
            return text == nil ? 8 : 10
        case .capsule:
            return text == nil ? 16 : 20
        case .mini:
            return text == nil ? 9 : 10
        }
    }
    
    private var verticalPadding: CGFloat {
        switch type {
        case .primary:
            return text == nil ? 12 : 15
        case .secondary:
            return text == nil ? 12 : 15
        case .toolbar:
            return 10
        case .accessory:
            return text == nil ? 8 : 7
        case .capsule:
            return 15
        case .mini:
            return text == nil ? 8 : 7
        }
    }
    
    private var spacing: CGFloat {
        switch type {
        case .primary:
            return 7
        case .secondary:
            return 7
        case .toolbar:
            return 4
        case .accessory:
            return 5
        case .capsule:
            return 7
        case .mini:
            return 4
        }
    }
    
    var body: some View {
        Group {
            switch type {
            case .toolbar:
                toolbar
            default:
                generic
            }
        }
        .opacity(isEnabled ? 1 : 0.75)
        .saturation(isEnabled ? 1 : 0.75)
        .animation(.spring(duration: 0.3), value: isEnabled)
        .animation(.spring(duration: 0.3), value: symbol)
    }
    
    var generic: some View {
        HStack (spacing: spacing) {
            if symbolLocation == .leading && symbol != nil {
                Symbol(symbol: symbol!, size: symbolSize, colour: textColourCalculated)
            }
            
            if text != nil {
                Text(text!)
                    .if(type == .primary || type == .secondary || type == .accessory) { content in
                        content
                            .bodyText()
                    }
                    .if(type == .mini) { content in
                        content
                            .smallText()
                    }
                    .foregroundColor(textColourCalculated)
            }
            
            if symbolLocation == .trailing && symbol != nil {
                Symbol(symbol: symbol!, size: symbolSize, colour: textColourCalculated)
            }
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .frame(maxWidth: expandWidth ? .infinity : nil)
        .backgroundStroke(cornerRadius: cornerRadius, colour: outlineColourCalculated)
        .backgroundFill(cornerRadius: cornerRadius, colour: backgroundColourCalculated)
    }
    
    var toolbar: some View {
        HStack {
            if symbol != nil {
                if #available(iOS 26.0, *) {
                    Symbol(symbol: symbol!, size: symbolSize, colour: textColourCalculated)
                        .padding(.horizontal, horizontalPadding)
                        .padding(.vertical, verticalPadding)
                        .glassEffect(backgroundColour == nil ? .regular.interactive() : .regular.tint(backgroundColourCalculated))
                        .transition(.blurReplace)
                } else {
                    Symbol(symbol: symbol!, size: symbolSize, colour: textColourCalculated)
                        .padding(.horizontal, horizontalPadding)
                        .padding(.vertical, verticalPadding)
                        .background(
                            RoundedRectangle(cornerRadius: 100)
                                .fill(.ultraThinMaterial)
                        )
                        .shadow(color: .Control.black.opacity(0.2), radius: 20)
                        .transition(.blurReplace)
                }
            }
        }
    }
}

#Preview (traits: .controlPreview){
    @Previewable @State var bool: Bool = false
    VStack {
        ControlButton(text: "Hello", symbol: "Question", type: .primary, symbolLocation: .leading, expandWidth: false) {
            
        }
        ControlButton(symbol: "Question", type: .primary, symbolLocation: .leading, expandWidth: false) {
            
        }
        .disabled(bool)
        ControlButton(text: "Hello", symbol: "Question", type: .secondary, symbolLocation: .leading, expandWidth: false) {
            
        }
        ControlButton(symbol: "Question", type: .secondary, symbolLocation: .leading, expandWidth: false) {
            
        }
        .disabled(bool)
        ControlButton(text: "Hello", symbol: "Question", type: .capsule, symbolLocation: .leading, expandWidth: false) {
            
        }
        ControlButton(symbol: "Question", type: .capsule, symbolLocation: .leading, expandWidth: false) {
            
        }
        .disabled(bool)
        ControlButton(text: "Hello", symbol: "Question", type: .accessory,  symbolLocation: .leading) {
            
        }
        ControlButton(symbol: "Question", type: .accessory,  symbolLocation: .leading) {
            
        }
        ControlButton(text: "Hello", symbol: "Question", type: .mini, symbolLocation: .leading, expandWidth: false) {
            
        }
        ControlButton(symbol: "Question", type: .mini, symbolLocation: .leading, expandWidth: false, outlineColour: .Control.white) {
            
        }
        .disabled(bool)
        ControlButton(text: "Hello", symbol: "Question", type: .toolbar, symbolLocation: .trailing, expandWidth: false) {
            bool.toggle()
        }
        ControlButton(text: "Hello", symbol: "Question", type: .toolbar, symbolLocation: .trailing, expandWidth: false, backgroundColour: .accentColor, textColour: .Control.white) {
            bool.toggle()
        }
        
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.fill)
}
