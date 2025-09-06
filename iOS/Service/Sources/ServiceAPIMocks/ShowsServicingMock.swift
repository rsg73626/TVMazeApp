//
//  File.swift
//  Service
//
//  Created by Renan Germano on 04/09/25.
//

import Combine
import Domain
import ServiceAPI

public final class ShowsServicingMock: ShowsServicing {
    
    public var showsCallCount = 0
    public var episodesCallCount = 0
    
    public var showsHandler: ((UInt) -> AnyPublisher<ShowsResult, Error>)?
    public var episodesHandler: ((Int) -> AnyPublisher<[Episode], Error>)?
    
    public init() { }
    
    public func shows(page: UInt) -> AnyPublisher<ShowsResult, Error> {
        showsCallCount += 1
        
        return unwrapHandler(showsHandler)(page)
    }
    
    public func episodes(showId: Int) -> AnyPublisher<[Episode], Error> {
        episodesCallCount += 1
        
        return unwrapHandler(episodesHandler)(showId)
    }
    
    // MARK - Private
    
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
