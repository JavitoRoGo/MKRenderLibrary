import Foundation
import Markdown

/// El motor de la librería. Convierte un String Markdown en nuestro modelo interno de bloques.
internal struct MKParser: MarkupVisitor {
	
	// Propiedad para acumular los bloques. Al ser una 'struct', usamos mutating para cambiar esto.
	private var accumulatedBlocks: [MKBlock] = []

	/// Punto de entrada principal.
	mutating func parse(_ markdown: String) -> [MKBlock] {
		let document = Document(parsing: markdown)
		accumulatedBlocks = [] // Limpiamos para evitar duplicados en llamadas sucesivas
		visit(document)        // Iniciamos el recorrido del árbol
		return accumulatedBlocks
	}

	// MARK: - Visitor Methods
	
	mutating func visitText(_ text: Text) {
		// El texto plano no genera un bloque de nivel superior.
	}
	
	mutating func visitHeading(_ heading: Heading) {
		let level = heading.level
		let content = parseInlineText(heading)
		accumulatedBlocks.append(.heading(level: level, content: content))
	}
	
	mutating func visitParagraph(_ paragraph: Paragraph) {
		let content = parseInlineText(paragraph)
		accumulatedBlocks.append(.paragraph(content: content))
	}
	
	mutating func visitListItem(_ listItem: ListItem) {
		// Para el MVP, extraemos el contenido del item.
		let content = parseInlineText(listItem)
		accumulatedBlocks.append(.listItem(content: content, level: 0))
	}
	
	mutating func visitCodeBlock(_ codeBlock: CodeBlock) {
		let code = codeBlock.code
		var languageString: String? = nil
		if let langMarkup = codeBlock.language {
			languageString = String(describing: langMarkup)
		}
		accumulatedBlocks.append(.codeBlock(code: code, language: languageString))
	}
	
	mutating func visitBlockQuote(_ blockQuote: BlockQuote) {
		// En lugar de un bucle manual aquí, dejamos que defaultVisit 
		// maneje la recursión de forma genérica.
	}
	
	mutating func visitThematicBreak(_ thematicBreak: ThematicBreak) {
		accumulatedBlocks.append(.thematicBreak)
	}
	
	/// SOLUCIÓN AL PROBLEMA DE RECURSIÓN:
	/// Esta función es la que permite que el recorrido no se detenga.
	/// Si el nodo no es un Heading, Paragraph, etc., entra aquí y 
	/// recorremos sus hijos manualmente para seguir bajando en el árbol.
	mutating func defaultVisit(_ markup: Markup) {
		for child in markup.children {
			visit(child)
		}
	}
	
	// MARK: - Helpers (Paso 5: AttributedString)

	private func parseInlineText(_ node: Markup) -> AttributedString {
		let rawText = String(describing: node)
		do {
			return try AttributedString(markdown: rawText)
		} catch {
			return AttributedString(rawText)
		}
	}
}
