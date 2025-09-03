//
//  ShowsServicingWithRetry.swift
//  App
//
//  Created by Renan Germano on 02/09/25.
//

import Combine
import Domain
import Foundation
import ServiceAPI

final class RetryShowsService: ShowsServicing {
    
    init(
        service: ShowsServicing,
        retryCount: Int = 3
    ) {
        self.service = service
        self.retryCount = retryCount
    }
    
    func shows(page: UInt) -> AnyPublisher<ShowsResult, Error> {
        var errorStrategy: ErrorStrategy<ShowsResult> = .retry(
            publisher: shows(
                page: page,
                errorStrategy: .fail(Failure)
            )
        )
        
        for _ in 1..<retryCount {
            let retry = ErrorStrategy<ShowsResult>.retry(
                publisher: shows(
                    page: page,
                    errorStrategy: errorStrategy
                )
            )
            errorStrategy = retry
        }
        
        return shows(page: page, errorStrategy: errorStrategy)
    }
    
    func episodes(showId: Int) -> AnyPublisher<[Episode], Error> {
        var errorStrategy: ErrorStrategy<[Episode]> = .retry(
            publisher: episodes(
                showId: showId,
                onFailure: .fail(Failure)
            )
        )
        
        for _ in 1..<retryCount {
            let retry = ErrorStrategy<[Episode]>.retry(
                publisher: episodes(
                    showId: showId,
                    onFailure: errorStrategy
                )
            )
            errorStrategy = retry
        }
        
        return episodes(showId: showId, onFailure: errorStrategy)
    }
    
    // MARK: - Private
    
    private let service: ShowsServicing
    private let retryCount: Int
    private let cancellables = Set<AnyCancellable>()
    
    private enum ErrorStrategy<T> {
        case retry(publisher: AnyPublisher<T, Error>)
        case fail((Error) -> AnyPublisher<T, Error>)
        
        func value(error: Error) -> AnyPublisher<T, Error> {
            switch self {
            case let .retry(publisher): publisher
            case let .fail(handler): handler(error)
            }
        }
    }
    
    private func Failure<T>(error: Error) -> AnyPublisher<T, Error> {
        Fail<T, Error>(error: error)
            .eraseToAnyPublisher()
    }
    
    private func shows(page: UInt, errorStrategy: ErrorStrategy<ShowsResult>) -> AnyPublisher<ShowsResult, Error> {
        service
            .shows(page: page)
            .catch { error in
                errorStrategy.value(error: error)
            }
            .eraseToAnyPublisher()
    }
    
    private func episodes(showId: Int, onFailure: ErrorStrategy<[Episode]>) -> AnyPublisher<[Episode], Error> {
        service
            .episodes(showId: showId)
            .catch { error in
                onFailure.value(error: error)
            }
            .eraseToAnyPublisher()
    }
    
    
}
