//
//  Symbol.swift
//  UpGrade
//
//  Created by Romel Luis Faife Cruz on 2025-01-23.
//

import SwiftUI

public struct Symbol: View {
    @State var symbol: String
    @State var size: CGFloat
    @State var colour: Color = .Control.black
    
    public init(symbol: String, size: CGFloat, colour: Color = .Control.black) {
        self.symbol = symbol
        self.size = size
        self.colour = colour
    }
    
    public var body: some View {
        Image(symbol + " Symbol", bundle: .module)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size)
            .foregroundColor(colour)
    }
}

#Preview {
    Symbol(symbol: "Cog", size: 30)
}
