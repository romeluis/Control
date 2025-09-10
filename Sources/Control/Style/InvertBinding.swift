//
//  InvertBinding.swift
//  UpGrade
//
//  Created by Romel Luis Faife Cruz on 2025-03-24.
//

import SwiftUI

prefix func ! (value: Binding<Bool>) -> Binding<Bool> {
    Binding<Bool>(
        get: { !value.wrappedValue },
        set: { value.wrappedValue = !$0 }
    )
}
