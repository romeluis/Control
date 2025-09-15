//
//  ControlButtonLabel.swift
//  UpGrade
//
//  Created by Romel Luis Faife Cruz on 2025-08-06.
//

import SwiftUI

public struct ControlButtonLabel: View {
    @Environment(\.isEnabled) var isEnabled
    
    @Bindable var object: ControlButtonObject
    
    public init(text: String? = nil, symbol: String? = nil, type: ControlButtonType, symbolLocation: ControlButtonSymbolLocation = .leading, buttonLocation: Alignment = .center, expandWidth: Bool = false, backgroundColour: Color? = nil, outlineColour: Color? = nil, textColour: Color? = nil, action: @escaping () -> Void) {
        self._object = .init(wrappedValue: .init(text: text, symbol: symbol, type: type, symbolLocation: symbolLocation, buttonLocation: buttonLocation, expandWidth: expandWidth, backgroundColour: backgroundColour, outlineColour: outlineColour, textColour: textColour, action: action))
    }
    public init(_ object: ControlButtonObject) {
        self._object = .init(wrappedValue: object)
    }
    
    private var backgroundColourCalculated: Color {
        if let colour = object.backgroundColour {
            return colour
        }
        
        switch object.type {
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
    private var outlineColourCalculated: Color {
        if let colour = object.outlineColour {
            return colour
        }
        return .clear
    }
    private var textColourCalculated: Color {
        if let colour = object.textColour {
            return colour
        }
        
        switch object.type {
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
        switch object.type {
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
        switch object.type {
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
        switch object.type {
        case .primary:
            return object.text == nil ? 14 : 20
        case .secondary:
            return object.text == nil ? 14 : 20
        case .toolbar:
            return 10
        case .accessory:
            return object.text == nil ? 8 : 10
        case .capsule:
            return object.text == nil ? 16 : 20
        case .mini:
            return object.text == nil ? 9 : 10
        }
    }
    
    private var verticalPadding: CGFloat {
        switch object.type {
        case .primary:
            return object.text == nil ? 12 : 15
        case .secondary:
            return object.text == nil ? 12 : 15
        case .toolbar:
            return 10
        case .accessory:
            return object.text == nil ? 8 : 7
        case .capsule:
            return 15
        case .mini:
            return object.text == nil ? 8 : 7
        }
    }
    
    private var spacing: CGFloat {
        switch object.type {
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
    
    public var body: some View {
        Group {
            switch object.type {
            case .toolbar:
                toolbar
            default:
                generic
            }
        }
        .opacity(isEnabled ? 1 : 0.75)
        .saturation(isEnabled ? 1 : 0.75)
        .animation(.spring(duration: 0.3), value: isEnabled)
        .animation(.spring(duration: 0.3), value: object.symbol)
    }
    
    var generic: some View {
        HStack (spacing: spacing) {
            if object.symbolLocation == .leading && object.symbol != nil {
                Symbol(symbol: object.symbol!, size: symbolSize, colour: textColourCalculated)
            }
            
            if object.text != nil {
                Text(object.text!)
                    .if(object.type == .primary || object.type == .secondary || object.type == .accessory) { content in
                        content
                            .bodyText()
                    }
                    .if(object.type == .mini) { content in
                        content
                            .smallText()
                    }
                    .foregroundColor(textColourCalculated)
            }
            
            if object.symbolLocation == .trailing && object.symbol != nil {
                Symbol(symbol: object.symbol!, size: symbolSize, colour: textColourCalculated)
            }
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, verticalPadding)
        .frame(maxWidth: object.expandWidth ? .infinity : nil)
        .backgroundStroke(cornerRadius: cornerRadius, colour: outlineColourCalculated)
        .backgroundFill(cornerRadius: cornerRadius, colour: backgroundColourCalculated)
    }
    
    var toolbar: some View {
        ZStack (alignment: .topTrailing) {
            HStack {
                if object.symbol != nil {
                    if #available(iOS 26.0, *) {
                        Symbol(symbol: object.symbol!, size: symbolSize, colour: textColourCalculated)
                            .padding(.horizontal, horizontalPadding)
                            .padding(.vertical, verticalPadding)
                            .glassEffect(object.backgroundColour == nil ? .regular.interactive() : .regular.tint(backgroundColourCalculated))
                            .transition(.blurReplace)
                    } else {
                        Symbol(symbol: object.symbol!, size: symbolSize, colour: textColourCalculated)
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
            
            Group {
                if object.showIndicator {
                    HStack (alignment: .top) {
                        VStack (alignment: .trailing) {
                            Circle()
                                .fill(Color(object.indicatorColour ?? .accentColor))
                                .frame(width: 10, height: 10)
                        }
                    }
                }
            }
            .transition(.scale)
        }
    }
}

#Preview (traits: .controlPreview){
    @Previewable @State var bool: Bool = false
    @Previewable @State var obj: ControlButtonObject = .init(symbol: "Cog", type: .toolbar, showIndicator: true, indicatorColour: .Control.orange) {
        
    }
    VStack {
        ControlButton(text: "Hello", symbol: "Question", type: .primary, symbolLocation: .leading, expandWidth: false) {
            obj.indicatorColour = .red
        }
        ControlButton(symbol: "Question", type: .primary, symbolLocation: .leading, expandWidth: false) {
            obj.indicatorColour = .green
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
            obj.showIndicator.toggle()
        }
        
        ControlButton(obj)
        
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(.fill)
}
