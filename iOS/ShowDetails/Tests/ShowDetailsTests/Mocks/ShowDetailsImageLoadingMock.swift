//
//  File.swift
//  ShowDetails
//
//  Created by Renan Germano on 05/09/25.
//

import Combine
import Domain
@testable import ShowDetails
import UIKit

final class ImageLoadingMock: ImageLoading {
    
    var imageCallCount = 0
    
    var imageHandler: ((Show) -> AnyPublisher<UIImage, Never>)?
    
    // MARK: - ShowDetailsImageLoading
    
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
