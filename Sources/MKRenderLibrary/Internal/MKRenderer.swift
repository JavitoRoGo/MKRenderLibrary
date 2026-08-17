//
//  MKRenderer.swift
//  MKRenderLibrary
//
//  Created by Javier Rodríguez Gómez on 17/08/2026.
//


import SwiftUI

/// El encargado de transformar los bloques procesados en vistas de SwiftUI.
internal struct MKRenderer {
    
    let theme: MKTheme

    init(theme: MKTheme = .default) {
        self.theme = theme
    }

    /// Función principal que genera la vista a partir de una lista de bloques.
    func render(_ blocks: [MKBlock]) -> some View {
        VStack(alignment: .leading, spacing: theme.listIndent / 2) {
            ForEach(0..<blocks.count, id: \.self) { index in
                blockView(for: blocks[index])
            }
        }
    }

    @ViewBuilder
    private func blockView(for block: MKBlock) -> some View {
        // Usamos AnyView para romper la recursividad de tipos opacos que causa el error de compilación.
        switch block {
        case .heading(let level, let content):
            AnyView(headingView(level: level, content: content))
            
        case .paragraph(let content):
            AnyView(paragraphView(content: content))
            
        case .listItem(let content, let level):
            AnyView(listItemView(content: content, level: level))
            
        case .list(let items, _):
            // Implementación futura para listas anidadas
            AnyView(EmptyView())
            
        case .blockQuote(let contents):
            AnyView(blockQuoteView(contents: contents))
            
        case .codeBlock(let code, let language):
            AnyView(codeBlockView(code: code, language: language))
            
        case .thematicBreak:
            AnyView(
                Divider()
                    .padding(.vertical, theme.listIndent / 2)
            )
        }
    }

    // MARK: - Sub-views por tipo de bloque

    @ViewBuilder
    private func headingView(level: Int, content: AttributedString) -> some View {
        let font: Font = {
            switch level {
            case 1: return theme.headingFont
            case 2: return theme.headingFont.weight(.semibold)
            default: return theme.headingFont.weight(.medium)
            }
        }()
        
        Text(content)
            .font(font)
            .padding(.top, 8)
    }

    @ViewBuilder
    private func paragraphView(content: AttributedString) -> some View {
        Text(content)
            .font(theme.bodyFont)
    }

    @ViewBuilder
    private func listItemView(content: AttributedString, level: Int) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .font(theme.bodyFont)
                .foregroundColor(theme.accentColor)
            
            Text(content)
                .font(theme.bodyFont)
        }
        .padding(.leading, CGFloat(level) * theme.listIndent)
    }

    @ViewBuilder
    private func blockQuoteView(contents: [MKBlock]) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<contents.count, id: \.self) { index in
                blockView(for: contents[index])
            }
        }
        .padding(.leading, 12)
        .padding(.trailing, 12)
        .padding(.vertical, 8)
        .background(theme.blockQuoteColor)
        .cornerRadius(4)
    }

    @ViewBuilder
    private func codeBlockView(code: String, language: String?) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            if let language = language, !language.isEmpty {
                Text(language.uppercased())
                    .font(.caption2.monospaced())
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
            }
            
            Text(code)
                .font(theme.codeFont)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .background(Color.systemBackground)
                .cornerRadius(6)
        }
    }
}

// Helper para compatibilidad de color en entornos Apple (macOS/iOS)
#if os(macOS)
import AppKit
extension Color {
    static let systemBackground = Color(NSColor.windowBackgroundColor)
}
#else
import UIKit
extension Color {
    static let systemBackground = Color(UIColor.systemBackground)
}
#endif
