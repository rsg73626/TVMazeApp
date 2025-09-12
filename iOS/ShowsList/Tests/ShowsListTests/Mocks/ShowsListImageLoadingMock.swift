//
//  File.swift
//  ShowsList
//
//  Created by Renan Germano on 11/09/25.
//

import Domain
import Combine
@testable import ShowsList
import SwiftUI

final class ShowsListImageLoadingMock: ImageLoading {
    
    var imageCallCount = 0
    
    var imageHandler: ((Show) -> AnyPublisher<UIImage, Never>)?
    
    // MARK: - ShowsListImageLoadingMock
    
    func image(for show: Show) -> AnyPublisher<UIImage, Never> {
        imageCallCount += 1
        return unwrapHandler(imageHandler)(show)
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
