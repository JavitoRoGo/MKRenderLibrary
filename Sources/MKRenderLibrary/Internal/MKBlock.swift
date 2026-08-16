//
//  MKBlock.swift
//  MKRenderLibrary
//
//  Created by Javier Rodríguez Gómez on 16/08/2026.
//


import Foundation

/// Representa un bloque de contenido Markdown procesado.
/// Este es el "modelo intermedio" (Paso 3) que desacopla el parsing de la visualización.
internal enum MKBlock {
    case heading(level: Int, content: AttributedString)
    case paragraph(content: AttributedString)
    case listItem(content: AttributedString, level: Int)
    case list(items: [MKBlock], ordered: Bool) // Lista de elementos (que pueden ser otros bloques)
    case blockQuote(content: [MKBlock])
    case codeBlock(code: String, language: String?)
    case thematicBreak
}

/// Un helper interno para manejar el contenido de texto con formato.
/// Usamos AttributedString para aprovechar el parsing inline (Paso 5).
internal typealias AttributedString = Foundation.AttributedString
