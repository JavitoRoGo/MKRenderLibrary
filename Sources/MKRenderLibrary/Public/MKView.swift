//
//  MKView.swift
//  MKRenderLibrary
//
//  Created by Javier Rodríguez Gómez on 16/08/2026.
//


import SwiftUI

/// La vista principal para renderizar contenido Markdown en SwiftUI.
public struct MKView: View {
    let content: String
    
    // Usamos un nombre con guion bajo para indicar que es interno/de uso de la estructura
    internal var _theme: MKTheme = .default

    public init(content: String) {
        self.content = content
    }

    public var body: some View {
        // Por ahora, esto es un placeholder. 
        // En el siguiente paso implementaremos el Parser y el Renderer real.
        VStack(alignment: .leading, spacing: 10) {
            Text(content)
                .font(_theme.bodyFont)
        }
    }
}
