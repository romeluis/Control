//
//  Symbol.swift
//  UpGrade
//
//  Created by Romel Luis Faife Cruz on 2025-01-23.
//

import SwiftUI

struct Symbol: View {
    @State var symbol: String
    @State var size: CGFloat
    @State var colour: Color = Color(.label)
    
    var body: some View {
        Image(symbol + " Symbol")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: size)
            .foregroundColor(colour)
    }
}

#Preview {
    Symbol(symbol: "Cog", size: 30)
}
