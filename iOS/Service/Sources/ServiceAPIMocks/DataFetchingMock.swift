//
//  File.swift
//  Service
//
//  Created by Renan Germano on 06/09/25.
//

import Combine
import Foundation
import ServiceAPI

public final class DataFetchingMock: DataFetching {
    
    public var fetchDataCallCount = 0
    
    public var fetchDataHandler: ((URL) -> AnyPublisher<Data, Error>)?
    
    public init() { }
    
    // MARK: - DataFetching
    
    public func fetchData(for url: URL) -> AnyPublisher<Data, Error> {
        fetchDataCallCount += 1
        
        return unwrapHandler(fetchDataHandler)(url)
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
