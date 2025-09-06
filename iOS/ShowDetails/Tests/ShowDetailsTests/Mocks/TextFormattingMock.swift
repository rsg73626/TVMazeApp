//
//  File.swift
//  ShowDetails
//
//  Created by Renan Germano on 06/09/25.
//

import Domain
import Foundation
@testable import ShowDetails

final class TextFormattingMock: TextFormatting {
    
    var summaryCallCount = 0
    
    var summaryHandler: ((Show) -> AttributedString)?
    
    // MARK: - TextFormatting
    
    func summary(for show: Show) -> AttributedString {
        summaryCallCount += 1
        
        return unwrapHandler(summaryHandler)(show)
    }
    
    // MARK: - Private
    
    private func unwrapHandler<T>(
        _ handler: Optional<T>,
        file: StaticString = #filePath,
        function: StaticString = #function
    ) -> T {
        guard let handler else {
            fatalError("You must provide a handler before invoking \(file).\(function)")
        }
        return handler
    }
    
}
