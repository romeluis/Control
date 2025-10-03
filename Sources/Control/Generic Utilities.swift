//
//  Generic Utilities.swift
//  Control
//
//  Created by Romel Luis Faife Cruz on 2025-09-10.
//

import Foundation
import MathParser
import MapKit

public extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}

public func format(percent: Double, minimumDigits: Int = 0, maximumDigits: Int = 2) -> String {
    let number = percent * 100
    
    // Check if the number is whole, considering floating-point precision issues
    if number.truncatingRemainder(dividingBy: 1) == 0 {
        return "\(Int(number))"
    } else {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = minimumDigits
        formatter.maximumFractionDigits = maximumDigits
        // Use the formatter to convert the number; fall back if something goes wrong
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}

public func format(distance meters: CLLocationDistance) -> String { //MOVE TO CONTROL
    if meters < 1000 {
        return String(format: "%.0f m", meters)
    } else {
        return String(format: "%.1f km", meters / 1000)
    }
}

extension BinaryInteger {
    var degreesToRadians: CGFloat { CGFloat(self) * .pi / 180 }
}

extension FloatingPoint {
    var degreesToRadians: Self { self * .pi / 180 }
    var radiansToDegrees: Self { self * 180 / .pi }
}

public enum DoubleError: String, Error {
    case outOfBounds = "Value must be between 0 and 100"
    case invalid = "Value must be a valid number or expression"
}
public func sanitizeDouble(input: String) throws -> Double {
    // Remove leading/trailing whitespaces
    let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
    
    // First, try a direct conversion.
    if let direct = Double(trimmed) {
        // If the number is more than 1, treat it as a percentage (0-100)
        if direct > 1 {
            if direct > 100 || direct < 0 {
                throw DoubleError.outOfBounds
            }
            return direct / 100
        } else {
            // If it's in 0...1, assume it's already a fraction.
            return direct
        }
    }
    
    // If direct conversion didn't work, try evaluating as a math expression (e.g., "13/15")
    do {
        let evaluated = try trimmed.evaluate()
        if evaluated > 1 {
            if evaluated > 100 || evaluated < 0 {
                throw DoubleError.outOfBounds
            }
            return evaluated / 100
        } else {
            return evaluated
        }
    } catch {
        // If parsing fails, throw an error.
        throw DoubleError.invalid
    }
}
