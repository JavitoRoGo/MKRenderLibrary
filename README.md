# MKRenderLibrary 🚀

A lightweight, highly customizable SwiftUI library for rendering Markdown content with ease. Built on top of Apple's official `swift-markdown` package, `MKRenderLibrary` provides a seamless way to display rich text in your iOS and macOS applications.

## ✨ Features

- 🎨 **Customizable Theming**: Fully control fonts, colors, and indentation using the `MKTheme` struct.
- 📝 **Rich Inline Text**: Leverages `Foundation.AttributedString` to automatically handle bold, italics, and other inline styles.
- 🏗️ **SwiftUI Native**: Designed specifically for SwiftUI, making it easy to integrate into any modern Apple platform project.
- 🚀 **High Performance**: Decoupled architecture that separates parsing from rendering for optimal efficiency.

## 📦 Installation

Add `MKRenderLibrary` to your Swift Package Manager dependencies:

```swift
.package(url: "https://github.com/YOUR_USERNAME/MKRenderLibrary.git", branch: "main")
```

## 🚀 Quick Start

Rendering Markdown is as simple as passing a string to MKView:

```swift
import SwiftUI
import MKRenderLibrary

struct ContentView: View {
    let markdownContent = """
    # Hello World
    This is a **Markdown** rendered in *SwiftUI*!
    
    > "The best way to predict the future is to invent it."
    
    print("Hello, MKRenderLibrary!")
"""

    var body: some View {
      MKView(content: markdownContent)
          .padding()
    }
  }
```

## 🎨 Customizing the Theme

You can create a custom look and feel by providing your own `MKTheme`:

```swift
let myTheme = MKTheme(
    headingFont: .system(.title, design: .serif).bold(),
    bodyFont: .custom("AvenirNext-Regular", size: 16),
    accentColor: .purple,
    blockQuoteColor: Color.purple.opacity(0.1)
)

MKView(content: markdownContent)
    .theme(myTheme)
```
