//
// Divider.swift
// Control
//
// Created by Romel Luis Faife Cruz on 2025-09-10.

import SwiftUI
import SwiftData

struct HorizontalDivider: View {
    var colour: Color
    var width: CGFloat = 2
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(colour)
            .frame(height: width)
    }
}

struct VerticalDivider: View {
    var colour: Color
    var width: CGFloat = 2
    
    var body: some View {
        RoundedRectangle(cornerRadius: 30)
            .fill(colour)
            .frame(width: width)
    }
}