//
//  ControlSearchField.swift
//  Control
//
//  Created by Romel Luis Faife Cruz on 2025-09-12.
//

import SwiftUI

struct ControlSearchField: View {
    var title: String = ""
    
    @Binding var input: String
    @Binding var inputState: ControlInputState
    
    var placeholderText: String = ""
    var showError: Bool = true
    
    var backgroundColour: Color = .Control.white
    var outlineColour: Color = .Control.gray1
    var textColour: Color = .accentColor
    
    var search: (String) -> [String]
    
    @State var valueSelected: Bool = false
    
    @State var results: [String] = []
    
    var body: some View {
        VStack (alignment: .leading, spacing: 5) {
            
            //Title of textfield if present
            if !title.isEmpty {
                Text(title)
                    .smallText()
                    .padding(.leading, 7)
            }
            
            VStack {
                //Textfield
                HStack (spacing: 15) {
                    ControlTextField(input: $input, inputState: $inputState, placeholderText: placeholderText, showError: showError, backgroundColour: backgroundColour, outlineColour: outlineColour, textColour: textColour) { value in
                        if value.isEmpty {
                            return .valid
                        }
                        
                        results = search(value)
                        
                        if results.isEmpty {
                            return .invalid(message: "No results found")
                        }
                        
                        return .valid
                    }
                }
                
                if results.count > 0 && !valueSelected {
                    VStack {
                        ForEach(Array(results.enumerated()), id: \.offset) { index, result in
                            Button {
                                withAnimation (.spring(duration: 0.3)) {
                                    input = result
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                        withAnimation (.spring(duration: 0.3)) {
                                            valueSelected = true
                                        }
                                    }
                                }
                            } label: {
                                HStack {
                                    if index == 0 {
                                        Circle()
                                            .fill(textColour)
                                            .frame(width: 8, height: 8)
                                    } else {
                                        Circle()
                                            .stroke(lineWidth: 2)
                                            .foregroundColor(textColour)
                                            .frame(width: 6, height: 6)
                                    }
                                    Text(result)
                                        .bodyText()
                                    Spacer()
                                }
                                .padding(.horizontal, 5)
                                .padding(.vertical, 3)
                            }
                            
                            if index != results.count - 1 {
                                HorizontalDivider(colour: outlineColour)
                            }
                        }
                    }
                    .padding()
                    .backgroundFill(cornerRadius: 20, colour: backgroundColour)
                }
            }
        }
        .animation(.spring(duration: 0.3), value: results.count)
    }
}

#Preview (traits: .controlPreview) {
    @Previewable @State var input: String = ""
    @Previewable @State var state: ControlInputState = .valid
    @Previewable var options: [String] = ["One", "Two", "Three", "Four", "Five"]
    
    ScrollView {
        ControlSearchField(input: $input, inputState: $state) { string in
            return options.filter { $0.lowercased().contains(string.lowercased()) }
        }
        .padding()
    }
    .background(Rectangle().foregroundColor(.Control.gray1))
}
