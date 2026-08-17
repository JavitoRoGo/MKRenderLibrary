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
	
	internal var _theme: MKTheme = .default

	public init(content: String) {
		self.content = content
	}

	public var body: some View {
		// 1. Instanciamos el Parser (Internal)
		var parser = MKParser()
		
		// 2. Obtenemos los bloques (Paso 4 completado)
		let blocks = parser.parse(content)
		
		// 3. Usamos el Renderer para dibujar (Paso 6)
		MKRenderer(theme: _theme)
			.render(blocks)
	}
}
