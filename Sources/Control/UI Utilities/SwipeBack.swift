//
// SwipeBack.swift
// Control
//
// Created by Romel Luis Faife Cruz on 2025-09-10.

import SwiftUI

public struct SwipeBack: ViewModifier {
    
    var onEnded: (DragGesture.Value) -> Void
    
    public func body(content: Content) -> some View {
        content
            .overlay(alignment: .leading) {
                Rectangle()
                    .fill(.clear)
                    .frame(width: 44)
                    .frame(maxHeight: .infinity)
                    .contentShape(Rectangle())
                    .gesture(
                        DragGesture(minimumDistance: 30, coordinateSpace: .local)
                            .onEnded { value in
                                onEnded(value)
                            }
                    )
            }
    }
}
extension View {
    public func swipeBack(onEnded: @escaping (DragGesture.Value) -> Void) -> some View {
        modifier(SwipeBack(onEnded: onEnded))
    }
}
