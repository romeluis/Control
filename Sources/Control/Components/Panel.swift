//
//  Panel.swift
//  Control
//
//  Created by Romel Luis Faife Cruz on 2026-01-18.
//

import SwiftUI

public struct Panel<Content: View>: View {
    var title: String
    
    var actionIcon: String?
    var foregroundColour: Color = Color("UI Light 1")
    var backgroundColour: Color = Color("UI White")
    var action: () -> Void
    
    @ViewBuilder var content: Content
    
    public init(title: String, actionIcon: String? = nil, foregroundColour: Color, backgroundColour: Color, action: @escaping () -> Void, content: Content) {
        self.title = title
        self.actionIcon = actionIcon
        self.foregroundColour = foregroundColour
        self.backgroundColour = backgroundColour
        self.action = action
        self.content = content
    }
    
    public var body: some View {
        VStack {
            HStack {
                Text(title)
                    .bodyText()
                Spacer()
                if let icon = actionIcon {
                    ControlButton(symbol: icon, type: .accessory, action: action)
                        .padding(.vertical, -5)
                }
            }
            
            HorizontalDivider(colour: foregroundColour)
            
            VStack (spacing: 0) {
                content
            }
        }
        .padding()
        .backgroundFill(colour: backgroundColour)
    }
}
