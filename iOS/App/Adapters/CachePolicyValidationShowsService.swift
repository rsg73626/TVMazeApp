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
    
    static var now: () -> Double = {
        Date.now.timeIntervalSince1970
    }
    
    init(
        service: ShowsServicing,
        repo: ShowsPaginationRepository,
        cacheDurationInSeconds: Double
    ) {
        self.service = service
        self.repo = repo
        self.cacheDurationInSeconds = cacheDurationInSeconds
    }
    
    // MARK: - ShowsServicing
    
    func shows(page: UInt) -> AnyPublisher<ShowsResult, Error> {
        if page > 3 {
            return service.shows(page: page)
        }
        
        let repo = repo
        let service = service
        let pageId = String(page)
        
        return repo
            .pagination(id: pageId)
            .map { InternalResult.cache($0) }
            .catch { _ -> AnyPublisher<InternalResult, Error> in
                service
                    .shows(page: page)
                    .map { result in
                        InternalResult.api(result: result)
                    }
                    .eraseToAnyPublisher()
            }
            .flatMap { internalResult in
                switch internalResult {
                case let .cache(pagination):
                    return self.validateCache(
                        page: page,
                        pagination: pagination
                    )
                    .eraseToAnyPublisher()
                case .api(result: let result):
                    self.handleAPIResult(page: page, result: result)
                    return Just(result)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
        
//        return guy.eraseToAnyPublisher()
        
        // fetching local data
//        return repo
//            .pagination(id: pageId)
//            .catch { _ in
//                Just(([Show](), Self.now()))
//                    .setFailureType(to: Error.self)
//                    .eraseToAnyPublisher()
//            }
//            .map { pagination -> AnyPublisher<ShowsResult, Error> in
//                // validating local data
//                let now = Self.now()
//                if (now - pagination.timeStamp) < cacheDuration, !pagination.shows.isEmpty {
//                    // valid local data
//                    // extends local data duration with current time stamp
//                    self.update(pageId: pageId, timestamp: now)
//                    return Just(ShowsResult.shows(pagination.shows))
//                        .setFailureType(to: Error.self)
//                        .eraseToAnyPublisher()
//                } else {
//                    // invalid local data
//                    // deletes local data
//                    self.delete(pageId: pageId)
//                    return service
//                        .shows(page: page)
//                        .flatMap { result in
//                            switch result {
//                            case let .shows(shows):
//                                // saves data from api locally
//                                self.save(pageId: pageId, shows: shows)
//                                return Just(ShowsResult.shows(shows))
//                                    .setFailureType(to: Error.self)
//                                    .eraseToAnyPublisher()
//                            case .didFinish:
//                                return Just(ShowsResult.didFinish)
//                                    .setFailureType(to: Error.self)
//                                    .eraseToAnyPublisher()
//                            }
//                        }.eraseToAnyPublisher()
//                }
//            }
//            .switchToLatest()
//            .eraseToAnyPublisher()
    }
    
    func episodes(showId: Int) -> AnyPublisher<[Episode], Error> {
        service.episodes(showId: showId)
    }
    
    // MARK: - private
    
    private enum InternalResult {
        case api(result: ShowsResult)
        case cache((shows: [Show], timeStamp: Double))
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private let service: ShowsServicing
    private let repo: ShowsPaginationRepository
    private let cacheDurationInSeconds: Double
    
    private func validateCache(
        page: UInt,
        pagination: (shows: [Show], timeStamp: Double)
    ) -> AnyPublisher<ShowsResult, Error> {
        let pageId = String(page)
        let now = Self.now()
        if (now - pagination.timeStamp) >= cacheDurationInSeconds {
            self.delete(pageId: pageId)
            return service
                .shows(page: page)
                .handleEvents(
                    receiveOutput: { [weak self] result in
                        switch result {
                        case .didFinish:
                            break
                        case let .shows(shows):
                            self?.save(pageId: pageId, shows: shows)
                        }
                    }
                )
                .eraseToAnyPublisher()
        } else {
            self.update(pageId: pageId)
            return Just<ShowsResult>(.shows(pagination.shows))
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        
    }
    
    private func clearCancellables() {
        cancellables.forEach { $0.cancel() }
    }
    
    private func update(pageId: String) {
        clearCancellables()
        repo
            .update(id: pageId, timestamp: Self.now())
            .sink(
                receiveCompletion: { _ in
                    
                },
                receiveValue: {
                    
                }
            )
            .store(in: &cancellables)
    }
    
    private func delete(pageId: String) {
        clearCancellables()
        repo
            .delete(id: pageId)
            .sink(
                receiveCompletion: { error in },
                receiveValue: { }
            )
            .store(in: &cancellables)
    }
    
    private func save(pageId: String, shows: [Show]) {
        clearCancellables()
        repo
            .add(id: pageId, shows: shows, timestamp: Self.now())
            .sink(
                receiveCompletion: { error in },
                receiveValue: { }
            )
            .store(in: &cancellables)
    }
    
    private func handleAPIResult(
        page: UInt,
        result: ShowsResult
    ) {
        if case let .shows(shows) = result {
            self.save(pageId: String(page), shows: shows)
        }
    }
    
}
