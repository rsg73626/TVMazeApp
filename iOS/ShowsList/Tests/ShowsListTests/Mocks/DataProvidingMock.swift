//
//  File.swift
//  ShowsList
//
//  Created by Renan Germano on 12/09/25.
//

import Combine
import Domain
import Foundation
import ShowsListAPI

final class DataProvidingMock: DataProviding {
    
    var dataCallCount = 0
    
    var dataHandler: ((URL) -> AnyPublisher<Data, Error>)?
    
    // MARK: - DataProviding
    
    func data(for url: URL) -> AnyPublisher<Data, any Error> {
        dataCallCount += 1
        
        return unwrapHandler(dataHandler)(url)
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
