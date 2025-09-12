//
//  File.swift
//  ShowsList
//
//  Created by Renan Germano on 12/09/25.
//

import Combine
import Domain
import ShowsListAPI

final class ShowsProvidingMock: ShowsProviding {
    
    var showsCallCount = 0
    
    var showsHandler: ((UInt) -> AnyPublisher<ShowsResult, Error>)?

    // MARK: - ShowsProviding
    
    func shows(page: UInt) -> AnyPublisher<ShowsResult, Error> {
        showsCallCount += 1
        
        return unwrapHandler(showsHandler)(page)
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
