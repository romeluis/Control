//
//  DataPoint.swift
//  Control
//
//  Created by Romel Luis Faife Cruz on 2025-03-01.
//

import SwiftUI

public struct DataPoint {
    var x: Double
    var y: Double
    
    var colour: Color
	
	public init(x: Double, y: Double, colour: Color) {
		self.x = x
		self.y = y
		self.colour = colour
	}
}
