//
//  ControlColour.swift
//  Control
//
//  Created by Romel Luis Faife Cruz on 2025-09-10.
//

import SwiftUI

struct ControlColour: View {
    var title: String = "Colour"
    
    @Binding var input: Color
    
    var backgroundColour: Color = .Control.white
    
    var body: some View {
        VStack (alignment: .leading, spacing: 5) {
            
            if !title.isEmpty {
                Text(title)
                    .smallText()
                    .padding(.leading, 7)
            }
            
            HStack(spacing: 5) {
                ForEach(Color.Control.allCases, id: \.rawValue) { colour in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("\(colour.rawValue)", bundle: .module))
                        .frame(maxWidth: .infinity)
                        .padding(5)
                        .backgroundStroke(cornerRadius: 15, colour: Color("\(colour.rawValue)", bundle: .module) == input ? .accentColor : .clear)
                        .aspectRatio(1, contentMode: .fit)
                        .onTapGesture {
                            withAnimation(.spring(duration: 0.2)) {
                                input = Color("\(colour.rawValue)", bundle: .module)
                            }
                        }
                }
            }
            .padding()
            .backgroundFill(cornerRadius: 20, colour: backgroundColour)
        }
    }
}

#Preview (traits: .controlPreview) {
    @Previewable @State var input: Color = .black
    VStack {
        ControlColour(input: $input)
        Spacer()
        
        RoundedRectangle(cornerRadius: 20)
            .fill(input)
            .frame(width: 100, height: 100)
    }
    .padding()
    .background(.fill)
}
