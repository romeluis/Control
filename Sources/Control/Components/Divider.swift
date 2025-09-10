//
// Divider.swift
// Control
//
// Created by Romel Luis Faife Cruz on 2025-09-10.

import SwiftUI
import SwiftData

public struct HorizontalDivider: View {
    var colour: Color
    var width: CGFloat = 2
    
    public init(colour: Color, width: CGFloat = 2) {
        self.colour = colour
        self.width = width
    }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(colour)
            .frame(height: width)
    }
}

public struct VerticalDivider: View {
    var colour: Color
    var width: CGFloat = 2
    
    public init(colour: Color, width: CGFloat = 2) {
        self.colour = colour
        self.width = width
    }
    
    public var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(colour)
            .frame(width: width)
    }
}