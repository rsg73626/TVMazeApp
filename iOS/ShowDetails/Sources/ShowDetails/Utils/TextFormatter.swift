//
//  File.swift
//  ShowDetails
//
//  Created by Renan Germano on 06/09/25.
//

import Domain
import Foundation

protocol TextFormatting {
    func summary(for show: Show) -> AttributedString
}

final class TextFormatter: TextFormatting {
    
    init() { }
    
    // MARK: - TextFormatting
    
    func summary(for show: Show) -> AttributedString {
        AttributedString(html: show.summary)?.removingFonts() ?? .init("")
    }
    
}

fileprivate extension AttributedString {
    
    init?(html: String) {
        let htmlBase = """
        <style>
        body { font: -apple-system-body; font-size: 17px; }
        p { margin: 0 0 8px; }
        </style>
        """
        let html = htmlBase + html
        guard let data = html.data(using: .utf8) else { return nil }
        do {
            let ns = try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            self = AttributedString(ns)
        } catch {
            return nil
        }
    }
    
    func removingFonts() -> AttributedString {
        var copy = self
        for run in copy.runs {
            if run.attributes.font != nil {
                copy[run.range].font = nil
            }
        }
        return copy
    }
    
}
