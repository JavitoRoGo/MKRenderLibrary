import Foundation
import Markdown

/// El motor de la librería. Convierte un String Markdown en nuestro modelo interno de bloques.
internal struct MKParser: MarkupVisitor {
	
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

    // Eliminamos la función visitCodeBlock que causaba error de compilación
	
	mutating func visitBlockQuote(_ blockQuote: BlockQuote) {
		// En lugar de un bucle manual aquí, dejamos que defaultVisit 
		// maneje la recursión de forma genérica.
	}
	
	mutating func visitThematicBreak(_ thematicBreak: ThematicBreak) {
		accumulatedBlocks.append(.thematicBreak)
	}
	
	mutating func defaultVisit(_ markup: Markup) {
		print("DEBUG: Visitando nodo de tipo: \(type(of: markup))")
		
        let mirror = Mirror(reflecting: markup)
        if String(describing: mirror.subjectType).contains("CodeBlock") {
            // Usamos reconstructMarkdown para obtener el contenido del bloque
            let code = reconstructMarkdown(from: markup)
            
            var language: String? = nil
            for child in mirror.children {
                if let label = child.label, (label == "language" || label == "_language") {
                    let langVal = "\(child.value)"
                    if !langVal.contains("nil") && !langVal.isEmpty {
                        language = langVal.replacingOccurrences(of: "Optional(", with: "").replacingOccurrences(of: ")", with: "")
                    }
                }
            }
            
            // Si el código extraído es vacío, imprimimos para debug
            if code.isEmpty { print("DEBUG: El bloque de código se extrajo como STRING VACÍO") }
            
            accumulatedBlocks.append(.codeBlock(code: code, language: language))
        } else {
            for child in markup.children {
                visit(child)
            }
        }
	}
	
	// MARK: - Helpers (Paso 5: AttributedString)

	private func parseInlineText(_ node: Markup) -> AttributedString {
		let rawMarkdown = reconstructMarkdown(from: node)
		
		do {
			return try AttributedString(markdown: rawMarkdown)
		} catch {
			return AttributedString(rawMarkdown)
		}
	}

	private func reconstructMarkdown(from node: Markup) -> String {
		var result = ""
		
		for child in node.children {
			if let text = child as? Text {
				result += text.string
			} else if let strong = child as? Strong {
				result += "**" + reconstructMarkdown(from: strong) + "**"
			} else if let emphasis = child as? Emphasis {
				result += "*" + reconstructMarkdown(from: emphasis) + "*"
			} else if let link = child as? Link {
				result += "[" + reconstructMarkdown(from: link) + "]"
			} else if !Array(child.children).isEmpty {
				// Si el nodo tiene hijos pero no es uno de los tipos anteriores, 
				// seguimos bajando recursivamente hasta encontrar Text.
				result += reconstructMarkdown(from: child)
			} else {
				// Si llegamos aquí es porque es un nodo hoja que no es 'Text'.
				// Intentamos extraer su valor mediante reflexión de forma muy específica.
				let mirror = Mirror(reflecting: child)
				if let firstChild = mirror.children.first, let val = firstChild.value as? String {
					result += val
				}
			}
		}
		
		return result
	}
}

// (Eliminado AnyCodeBlockProxy ya que no es necesario)
