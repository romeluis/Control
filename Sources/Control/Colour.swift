//
//  Colour.swift
//  Control
//
//  Created by Romel Luis Faife Cruz on 2025-09-10.
//

import SwiftUI

public extension Color {
    enum Control: String, CaseIterable {
        case orangeColour = "Orange"
        case greenColour = "Green"
        case blueColour = "Blue"
        case pinkColour = "Pink"
        case purpleColour = "Purple"
        case yellowColour = "Yellow"
    } // namespace
}

public extension Color.Control {
    static var white: Color { Color("UI White", bundle: .module) }
    static var black: Color { Color("UI Black", bundle: .module) }
    static var gray1: Color { Color("UI Light 1", bundle: .module) }
    static var gray2: Color { Color("UI Light 2", bundle: .module) }
    static var gray3: Color { Color("UI Light 3", bundle: .module) }
    static var gray4: Color { Color("UI Light 4", bundle: .module) }
    
    static var orange: Color { Color("Orange", bundle: .module) }
    static var blue: Color { Color("Blue", bundle: .module) }
    static var purple: Color { Color("Purple", bundle: .module) }
    static var green: Color { Color("Green", bundle: .module) }
    static var pink: Color { Color("Pink", bundle: .module) }
    static var yellow: Color { Color("Yellow", bundle: .module) }
}

public extension ShapeStyle where Self == Color {
    static var white: Color { Color("UI White", bundle: .module) }
    static var black: Color { Color("UI Black", bundle: .module) }
    static var gray1: Color { Color("UI Light 1", bundle: .module) }
    static var gray2: Color { Color("UI Light 2", bundle: .module) }
    static var gray3: Color { Color("UI Light 3", bundle: .module) }
    static var gray4: Color { Color("UI Light 4", bundle: .module) }
    
    static var orange: Color { Color("Orange", bundle: .module) }
    static var blue: Color { Color("Blue", bundle: .module) }
    static var purple: Color { Color("Purple", bundle: .module) }
    static var green: Color { Color("Green", bundle: .module) }
    static var pink: Color { Color("Pink", bundle: .module) }
    static var yellow: Color { Color("Yellow", bundle: .module) }
}
