//
// AnimatablePath.swift
// Control
//
// Created by Romel Luis Faife Cruz on 2025-09-10.

import SwiftUI

public struct AnimatablePath: Shape {
    var start: CGPoint
    var end: CGPoint

    public init(start: CGPoint, end: CGPoint) {
        self.start = start
        self.end = end
    }
    
    // For now, animate only the endpoints (geometry)
    public var animatableData: AnimatablePair<
        AnimatablePair<CGFloat, CGFloat>,
        AnimatablePair<CGFloat, CGFloat>
    > {
        get {
            AnimatablePair(
                AnimatablePair(start.x, start.y),
                AnimatablePair(end.x, end.y)
            )
        }
        set {
            start = CGPoint(x: newValue.first.first, y: newValue.first.second)
            end = CGPoint(x: newValue.second.first, y: newValue.second.second)
        }
    }
    
    public func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: start)
        path.addLine(to: end)
        return path
    }
}
