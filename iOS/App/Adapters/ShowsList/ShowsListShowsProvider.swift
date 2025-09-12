//
//  ShowsListShowsProvider.swift
//  App
//
//  Created by Renan Germano on 12/09/25.
//

import Combine
import Domain
import ShowsListAPI
import ServiceAPI

final class ShowsListShowsProvider: ShowsListAPI.ShowsProviding {
    
    init(service: ShowsServicing) {
        self.service = service
    }
    
    // MARK: - ShowsProviding
    
    func shows(page: UInt) -> AnyPublisher<ShowsListAPI.ShowsResult, Error> {
        service
            .shows(page: page)
            .map { ShowsListAPI.ShowsResult($0) }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private
    
    private let service: ShowsServicing
    
}

fileprivate extension ShowsListAPI.ShowsResult {
    init(_ result: ServiceAPI.ShowsResult) {
        switch result {
        case .didFinish:
            self = .didFinish
        case let .shows(shows):
            self = .shows(shows)
        }
    }
}
