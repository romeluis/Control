//
//  Colour.swift
//  Control
//
//  Created by Romel Luis Faife Cruz on 2025-09-10.
//

import SwiftUI

public extension Color {
    enum Control { } // namespace
}

public extension Color.Control {
    static var white: Color { Color("UI White", bundle: .module) }
    static var black: Color { Color("UI Black", bundle: .module) }
    static var gray1: Color { Color("UI Light 1", bundle: .module) }
    static var gray2: Color { Color("UI Light 2", bundle: .module) }
    static var gray3: Color { Color("UI Light 3", bundle: .module) }
    static var gray4: Color { Color("UI Light 4", bundle: .module) }
}
