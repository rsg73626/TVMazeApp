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
    
    public var showsHandler: ((UInt) -> AnyPublisher<ShowsResult, Error>)!
    public var episodesHandler: ((Int) -> AnyPublisher<[Episode], Error>)!
    
    public init() { }
    
    public func shows(page: UInt) -> AnyPublisher<ShowsResult, Error> {
        showsCallCount += 1
        
        return showsHandler(page)
    }
    
    public func episodes(showId: Int) -> AnyPublisher<[Episode], Error> {
        episodesCallCount += 1
        
        return episodesHandler(showId)
    }

}
