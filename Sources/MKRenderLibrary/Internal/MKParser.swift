import Foundation
import Markdown

/// El motor de la librería. Convierte un String Markdown en nuestro modelo interno de bloques.
internal struct MKParser: MarkupVisitor<Void> {
	
	// Propiedad para acumular los bloques. Al ser una 'struct', usamos mutating para cambiar esto.
	private var accumulatedBlocks: [MKBlock] = []

	/// Punto de entrada principal.
	mutating func parse(_ markdown: String) -> [MKBlock] {
		let document = Document(parsing: markdown)
		accumulatedBlocks = []
		visit(document)
		return accumulatedBlocks
	}

	// MARK: - Visitor Methods

	mutating func visitText(_ text: Text) -> Void {
		// No hacemos nada con el texto plano directamente en el nivel de bloque.
		return
	}

	mutating func visitHeading(_ heading: Heading) -> Void {
		let level = heading.level
		let content = parseInlineText(heading)
		accumulatedBlocks.append(.heading(level: level, content: content))
		return
	}

	mutating func visitParagraph(_ paragraph: Paragraph) -> Void {
		let content = parseInlineText(paragraph)
		accumulatedBlocks.append(.paragraph(content: content))
		return
	}

	mutating func visitListItem(_ listItem: ListItem) -> Void {
		// Para el MVP, extraemos el contenido del item.
		let content = parseInlineText(listItem)
		accumulatedBlocks.append(.listItem(content: content, level: 0))
		return
	}

	mutating func visitCodeBlock(_ codeBlock: CodeBlock) -> Void {
		let code = codeBlock.code
		// Acceso correcto al lenguaje (es un elemento Markup que puede ser Text)
		var languageString: String? = nil
		if let langMarkup = codeBlock.language {
			// Convertimos el markup del lenguaje a string de forma segura
			languageString = String(describing: langMarkup)
		}
		
		accumulatedBlocks.append(.codeBlock(code: code, language: languageString))
		return
	}

	mutating func visitBlockQuote(_ blockQuote: BlockQuote) -> Void {
		// Para permitir que los elementos dentro del blockquote (como párrafos)
		// sean visitados y añadidos a accumulatedBlocks, visitamos sus hijos.
		for child in blockQuote.children {
			visit(child)
		}
		return
	}

	mutating func visitThematicBreak(_ thematicBreak: ThematicBreak) -> Void {
		accumulatedBlocks.append(.thematicBreak)
		return
	}

	mutating func defaultVisit(_ markup: Markup) -> Void {
		// No hacemos nada por defecto
		return
	}

	// MARK: - Helpers (Paso 5: AttributedString)

	private func parseInlineText(_ node: Markup) -> AttributedString {
		// Usamos String(describing:) que es la forma estándar y segura de
		// obtener la representación textual de un nodo Markup en swift-markdown.
		let rawText = String(describing: node)
		
		do {
			// Aprovechamos el parser de Foundation para los estilos inline
			return try AttributedString(markdown: rawText)
		} catch {
			return AttributedString(rawText)
		}
	}
}
