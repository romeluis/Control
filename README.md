# Control

A comprehensive Swift package providing custom SwiftUI controls, components, and utilities for building modern iOS and macOS applications.

## Installation

Add this package to your Xcode project using Swift Package Manager:

1. In Xcode, go to File > Add Package Dependencies
2. Enter the repository URL: `https://github.com/romeluis/Control.git`
3. Click Add Package

## Usage

Import the Control module and use any of the available controls:

```swift
import SwiftUI
import Control

struct ContentView: View {
    @State private var isToggled = false
    @State private var textInput = ""
    @State private var dateInput = Date()
    
    var body: some View {
        VStack(spacing: 20) {
            ControlToggle(
                title: "Settings",
                input: $isToggled,
                activatedText: "Enabled",
                deactivatedText: "Disabled"
            )
            
            ControlTextField(
                title: "Name",
                input: $textInput,
                placeholderText: "Enter your name"
            )
            
            ControlDatePicker(
                title: "Date of Birth",
                input: $dateInput
            )
        }
        .padding()
    }
}
```

## Components

### Control Components

#### ControlButton
A versatile button component with multiple styles and configurations.
- **Types**: `.primary`, `.secondary`, `.accessory`, `.mini`, `.capsule`, `.toolbar`
- **Features**: Custom symbols, text, expandable width, multiple color options
- **Symbol Locations**: Leading or trailing positions

#### ControlToggle
A customizable toggle control with title and state text display.
- **Features**: Custom on/off text, color theming, container styling

#### ControlTextField
A text input field with validation and error handling.
- **Features**: Title labels, placeholder text, input validation, error messages
- **Validation**: Real-time validation with custom validation functions

#### ControlDatePicker
A comprehensive date picker with multiple display modes.
- **Features**: Date and time selection, date range validation, compact display options
- **Modes**: Include/exclude date, year, and time components

#### ControlDouble & ControlOptionalDouble
Numeric input controls for Double values.
- **Features**: Validation, formatting, optional value handling

#### ControlColour
A color picker component using predefined color palettes.
- **Features**: Visual color selection from Control color scheme

#### String & Enum Pickers
Multiple picker components for different selection needs:
- **ControlStringPicker**: Standard string selection with validation
- **ControlCompactStringPicker**: Compact picker for limited space
- **ControlEnumPicker**: Type-safe enum selection
- **ControlCompactEnumPicker**: Compact enum picker
- **ControlCompactDatePicker**: Space-efficient date selection

#### Selection Controls
Advanced selection components for complex UI needs:
- **ControlCustomSelector**: Custom selectable items with content views
- **ControlCustomGroupSelector**: Grouped selection with custom content
- **ControlGroupSelector**: Standard grouped selection interface

#### ControlSearchField
A search input field with real-time filtering and validation.
- **Features**: Live search results, validation, customizable filtering

### UI Components

#### Symbol
A component for displaying custom symbols from the package's symbol library.
- **Features**: Size control, color theming, extensive symbol collection

#### Callout
An informational display component with symbol and text.
- **Features**: Title, body text, symbol integration, custom styling

#### Divider
Horizontal and vertical divider components.
- **Types**: `HorizontalDivider`, `VerticalDivider`
- **Features**: Custom colors, width control

#### Background Modifiers
View modifiers for consistent background styling:
- **backgroundFill**: Filled background with corner radius
- **backgroundStroke**: Stroke outline with corner radius

### Chart Components

#### LineChart & LineChartView
Data visualization components for line charts.
- **Features**: Custom data points, axis labels, color theming
- **DataPoint**: Structure for chart data with x/y coordinates and colors

### UI Utilities

#### Animation Utilities
- **AnimatablePath**: Custom shape with animatable start and end points
- **DynamicSlideHorizontal/Vertical**: Slide transition animations

#### Interaction Utilities
- **SwipeBack**: Gesture modifier for swipe-to-go-back functionality
- **ConditionalModifier**: Conditional view modification with `.if()` syntax
- **InvertBinding**: Utility for inverting boolean bindings

### Theme & Styling

#### Color System
Comprehensive color system with predefined palettes:
- **Control Colors**: Orange, Green, Blue, Pink, Purple, Yellow
- **UI Colors**: White, Black, Gray variants (gray1-gray4)
- **Usage**: `Color.Control.blue`, `Color.Control.gray1`

#### Typography
Custom font integration with CreatoDisplay font family:
- **Weights**: Regular, Black
- **Auto-registration**: Fonts automatically registered in previews

## Dependencies

- **DDMathParser**: For advanced mathematical expression parsing in numeric inputs

## Requirements

- iOS 18.0+ / macOS 14.0+
- Swift 6.2+
- Xcode 16.0+

## Features

- **Comprehensive Form Controls**: Complete set of input controls for any form requirement
- **Consistent Design Language**: Unified styling and theming across all components
- **Built-in Validation**: Real-time validation with custom validation functions
- **Accessibility**: Full accessibility support across all components
- **Dark Mode**: Automatic dark mode support with adaptive colors
- **Customizable**: Extensive customization options for colors, sizing, and behavior
- **Type Safety**: Leverages Swift's type system for safe enum and data handling
- **Preview Support**: Rich preview support with custom preview traits

## Architecture

The package is organized into several modules:

- **Control/**: Core input and selection controls
- **Components/**: Reusable UI components and layouts
- **UI Utilities/**: Helper utilities and view modifiers
- **Resources/**: Fonts, colors, and image assets

This modular structure allows for easy maintenance and selective importing of functionality.
