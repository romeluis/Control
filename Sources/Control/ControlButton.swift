//
//  ControlButton.swift
//  UpGrade
//
//  Created by Romel Luis Faife Cruz on 2025-05-20.
//

import SwiftUI

enum ControlButtonStyle {
    case none
    case circleFill
    case circleStroke
    case squareFill
    case squareStroke
}

enum ControlButtonSymbolLocation {
    case leading
    case trailing
}

enum ControlButtonType {
    case primary
    case secondary
    case accessory
    case mini
    case component
    case toolbar
}

struct ControlButton: View {
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
    
    var action: () -> Void
    
    var body: some View {
        Button {
            withAnimation(.spring(duration: 0.3)) {
                action()
            }
        } label: {
            ControlButtonLabel(text: text, symbol: symbol, type: type, symbolLocation: symbolLocation, buttonLocation: buttonLocation, expandWidth: expandWidth, backgroundColour: backgroundColour, outlineColour: outlineColour, textColour: textColour)
        }
        .if(buttonLocation == .leading || buttonLocation == .trailing) { content in
            content
                .frame(maxWidth: .infinity, alignment: buttonLocation)
        }
    }
}

#Preview {
    VStack {
        ControlButton(text: "Hello", symbol: "Check", type: .primary, symbolLocation: .leading, expandWidth: false) {
            
        }
        ControlButton(text: "Hello", symbol: "Check", type: .secondary, symbolLocation: .leading, expandWidth: false) {
            
        }
        ControlButton(text: "Hello", symbol: "Check", type: .accessory,  symbolLocation: .leading, buttonLocation: .trailing, expandWidth: false) {
            
        }
        ControlButton(text: "Hello", symbol: "Check", type: .mini, symbolLocation: .trailing, expandWidth: false) {
            
        }
        .disabled(true)
        
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
