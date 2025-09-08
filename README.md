# Control

A Swift package providing custom SwiftUI controls.

## Installation

Add this package to your Xcode project using Swift Package Manager:

1. In Xcode, go to File > Add Package Dependencies
2. Enter the repository URL: `https://github.com/romeluis/Control.git`
3. Click Add Package

## Usage

Import the Control module and use the `ControlToggle` view:

```swift
import SwiftUI
import Control

struct ContentView: View {
    @State private var isToggled = false
    
    var body: some View {
        ControlToggle(
            title: "Settings",
            input: $isToggled,
            activatedText: "Enabled",
            deactivatedText: "Disabled"
        )
        .padding()
    }
}
```

## Components

### ControlToggle

A customizable toggle control with title and on/off text display.

**Parameters:**
- `title`: Optional title text above the toggle
- `input`: Binding to a Bool value
- `activatedText`: Text shown when toggle is on (default: "On")
- `deactivatedText`: Text shown when toggle is off (default: "Off")
- `textColour`: Color for the on/off text (default: accent color)
- `containerColour`: Background color of the container (default: white)
- `outlineColour`: Border color of the container (default: clear)

## Requirements

- iOS 17.0+ / macOS 14.0+
- Swift 6.2+
