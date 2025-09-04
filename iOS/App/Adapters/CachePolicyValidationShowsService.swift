//
//  CacheShowsService.swift
//  App
//
//  Created by Renan Germano on 03/09/25.
//

import Combine
import Domain
import Foundation
import LocalAPI
import ServiceAPI

final class CachePolicyValidationShowsService: ShowsServicing {
    
    init(
        service: ShowsServicing,
        repo: ShowsPaginationRepository
    ) {
        self.service = service
        self.repo = repo
    }
    
    // MARK: - ShowsServicing
    
    private static func now() -> Double {
        Date.now.timeIntervalSince1970
    }
    
    private static let cacheDuration: Double = 15 * 60 * 1000
    
    func shows(page: UInt) -> AnyPublisher<ShowsResult, Error> {
        let repo = repo
        let service = service
        let cacheDuration = Self.cacheDuration
        
        // fetching local data
        return repo
            .pagination(id: String(page))
            .map { pagination -> AnyPublisher<ShowsResult, Error> in
                // validating local data
                let now = Self.now()
                if (now - pagination.timeStamp) < cacheDuration {
                    // valid local data
                    // extends local data duration with current time stamp
                    return repo
                        .update(
                            id: String(page),
                            timestamp: now
                        )
                        // return local data
                        .flatMap {
                            Just(ShowsResult.shows(pagination.shows))
                                .setFailureType(to: Error.self)
                        }
                        .eraseToAnyPublisher()
                } else {
                    // invalid local data
                    // deletes local data
                    return repo
                        .delete(id: String(page))
                        // reaches api
                        .flatMap {
                            service
                                .shows(page: page)
                                .flatMap { result in
                                    switch result {
                                    case let .shows(shows):
                                        // saves data from api locally
                                        return repo
                                            .add(id: String(page), shows: shows, timestamp: Self.now())
                                            .map {
                                                ShowsResult.shows(shows)
                                            }
                                            .eraseToAnyPublisher()
                                    case .didFinish:
                                        return Just(ShowsResult.didFinish)
                                            .setFailureType(to: Error.self)
                                            .eraseToAnyPublisher()
                                    }
                                }.eraseToAnyPublisher()
                        }
                        .eraseToAnyPublisher()
                }
            }
            .switchToLatest()
            .eraseToAnyPublisher()
    }
    
    func episodes(showId: Int) -> AnyPublisher<[Episode], Error> {
        service.episodes(showId: showId)
    }
    
    // MARK: - private
    
    private let service: ShowsServicing
    private let repo: ShowsPaginationRepository
    
    
}
