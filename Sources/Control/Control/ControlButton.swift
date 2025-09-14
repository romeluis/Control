//
//  ControlButton.swift
//  UpGrade
//
//  Created by Romel Luis Faife Cruz on 2025-05-20.
//

import SwiftUI

public enum ControlButtonSymbolLocation {
    case leading
    case trailing
}

public enum ControlButtonType {
    case primary
    case secondary
    case accessory
    case mini
    case capsule
    case toolbar
}

@Observable
public final class ControlButtonObject: Identifiable, Hashable {
    public let id: UUID = UUID()
    
    public var text: String?
    public var symbol: String?
    
    public var type: ControlButtonType
    public var symbolLocation: ControlButtonSymbolLocation = .leading
    public var buttonLocation: Alignment = .center
    public var expandWidth: Bool = false
    
    public var backgroundColour: Color? = nil
    public var outlineColour: Color? = nil
    public var textColour: Color? = nil
    
    public var action: () -> Void
    
    init(text: String? = nil, symbol: String? = nil, type: ControlButtonType, symbolLocation: ControlButtonSymbolLocation = .leading, buttonLocation: Alignment = .center, expandWidth: Bool = false, backgroundColour: Color? = nil, outlineColour: Color? = nil, textColour: Color? = nil, action: @escaping () -> Void) {
        self.text = text
        self.symbol = symbol
        self.type = type
        self.symbolLocation = symbolLocation
        self.buttonLocation = buttonLocation
        self.expandWidth = expandWidth
        self.backgroundColour = backgroundColour
        self.outlineColour = outlineColour
        self.textColour = textColour
        self.action = action
    }
    init(text: String? = nil, symbol: String? = nil, type: ControlButtonType, symbolLocation: ControlButtonSymbolLocation = .leading, buttonLocation: Alignment = .center, expandWidth: Bool = false, backgroundColour: Color? = nil, outlineColour: Color? = nil, textColour: Color? = nil) {
        self.text = text
        self.symbol = symbol
        self.type = type
        self.symbolLocation = symbolLocation
        self.buttonLocation = buttonLocation
        self.expandWidth = expandWidth
        self.backgroundColour = backgroundColour
        self.outlineColour = outlineColour
        self.textColour = textColour
        self.action = {}
    }
    
    // MARK: - Hashable / Equatable
    public static func == (lhs: ControlButtonObject, rhs: ControlButtonObject) -> Bool {
        lhs.id == rhs.id
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

public struct ControlButton: View {
    @Environment(\.isEnabled) var isEnabled
    
    @Bindable var object: ControlButtonObject
    
    public init(text: String? = nil, symbol: String? = nil, type: ControlButtonType, symbolLocation: ControlButtonSymbolLocation = .leading, buttonLocation: Alignment = .center, expandWidth: Bool = false, backgroundColour: Color? = nil, outlineColour: Color? = nil, textColour: Color? = nil, action: @escaping () -> Void) {
        self._object = .init(wrappedValue: .init(text: text, symbol: symbol, type: type, symbolLocation: symbolLocation, buttonLocation: buttonLocation, expandWidth: expandWidth, backgroundColour: backgroundColour, outlineColour: outlineColour, textColour: textColour, action: action))
    }
    public init(_ object: ControlButtonObject) {
        self._object = .init(wrappedValue: object)
    }
    
    public var body: some View {
        Button {
            withAnimation(.spring(duration: 0.3)) {
                object.action()
            }
        } label: {
            ControlButtonLabel(object)
        }
        .if(object.buttonLocation == .leading || object.buttonLocation == .trailing) { content in
            content
                .frame(maxWidth: .infinity, alignment: object.buttonLocation)
        }
    }
}

#Preview (traits: .controlPreview) {
    @Previewable @State var objs: [ControlButtonObject] = [.init(text: "Initial", type: .primary, action: {})]
    ScrollView {
        ControlButton(text: "Hello", symbol: "Check Mark", type: .primary, symbolLocation: .leading, expandWidth: false) {
            
        }
        ControlButton(text: "Hello", symbol: "Check Mark", type: .secondary, symbolLocation: .leading, expandWidth: false) {
            
        }
        ControlButton(text: "Hello", symbol: "Check Mark", type: .accessory,  symbolLocation: .leading, buttonLocation: .trailing, expandWidth: false) {
            
        }
        ControlButton(text: "Hello", symbol: "Check Mark", type: .mini, symbolLocation: .trailing, expandWidth: false) {
            
        }
        .disabled(true)
        
        HStack {
            ForEach(objs) { o in
                ControlButton(o)
            }
        }
        
        ControlButton(text: "Change Type",type: .secondary) {
            if let first = objs.first {
                first.type = .secondary
                first.symbol = "Check Mark"
                first.text = "Changed!"
                first.action = {
                    first.type = .mini
                    first.action = {}
                }
            }
        }
        ControlButton(symbol: "Plus",type: .secondary) {
            objs.append(.init(text: "Added", type: .primary, action: {}))
        }
        ControlButton(symbol: "Minus",type: .secondary) {
            _ = objs.popLast()
        }
        
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
