//
//  Symbol.swift
//  UpGrade
//
//  Created by Romel Luis Faife Cruz on 2025-01-23.
//

import SwiftUI

@Observable
public final class SymbolObject: Identifiable {
    public var symbol: String
    public var size: CGFloat
    public var colour: Color = .Control.black
    
    public init(symbol: String, size: CGFloat, colour: Color) {
        self.symbol = symbol
        self.size = size
        self.colour = colour
    }
}

public struct Symbol: View {
    @Bindable var object: SymbolObject
    
    public init(symbol: String, size: CGFloat, colour: Color = .Control.black) {
        self._object = .init(wrappedValue: .init(symbol: symbol, size: size, colour: colour))
    }
    public init (_ object: SymbolObject) {
        self._object = .init(wrappedValue: object)
    }
    
    public var body: some View {
        Image(object.symbol + " Symbol", bundle: .module)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: object.size)
            .foregroundColor(object.colour)
    }
}

#Preview (traits: .controlPreview) {
    @Previewable @Bindable var obj: SymbolObject = .init(symbol: "Cog", size: 30, colour: .blue)
    @Previewable @State var objs: [SymbolObject] = [.init(symbol: "Cog", size: 30, colour: .blue)]
    Symbol(symbol: "Cog", size: 30)
    
    Symbol(obj)
    
    HStack {
        ForEach(objs) { o in
            Symbol(o)
        }
    }
    
    ControlButton(text: "Change Colour",type: .secondary) {
        obj.colour = .red
        if let first = objs.first {
            first.colour = .purple
        }
    }
    ControlButton(symbol: "Plus",type: .secondary) {
        objs.append(.init(symbol: "Check Mark", size: 30, colour: .green))
    }
    ControlButton(symbol: "Minus",type: .secondary) {
        _ = objs.popLast()
    }
}
