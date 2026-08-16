//
//  MKTheme.swift
//  MKRenderLibrary
//
//  Created by Javier Rodríguez Gómez on 16/08/2026.
//


import SwiftUI

/// Define el aspecto visual de los elementos Markdown.
public struct MKTheme : Sendable {
    public var headingFont: Font
    public var bodyFont: Font
    public var codeFont: Font
    public var accentColor: Color
    public var blockQuoteColor: Color
    public var listIndent: CGFloat

    public static let `default` = MKTheme(
		headingFont: .bold(.title)(),
        bodyFont: .body,
        codeFont: .system(.footnote, design: .monospaced),
        accentColor: .blue,
        blockQuoteColor: Color.gray.opacity(0.3),
        listIndent: 20
    )

    public init(
		headingFont: Font = .bold(.title)(),
        bodyFont: Font = .body,
        codeFont: Font = .system(.footnote, design: .monospaced),
        accentColor: Color = .blue,
        blockQuoteColor: Color = Color.gray.opacity(0.3),
        listIndent: CGFloat = 20
    ) {
        self.headingFont = headingFont
        self.bodyFont = bodyFont
        self.codeFont = codeFont
        self.accentColor = accentColor
        self.blockQuoteColor = blockQuoteColor
        self.listIndent = listIndent
    }
}

extension MKView {
    /// Aplica un tema personalizado a la vista de Markdown.
    public func theme(_ theme: MKTheme) -> Self {
        var copy = self
        copy._theme = theme
        return copy
    }
}
