//
//  LocalShowsService.swift
//  App
//
//  Created by Renan Germano on 03/09/25.
//

import Combine
import Domain
import Local
import ServiceAPI

final class LocalShowsService: ShowsServicing {
    
    init(service: ShowsServicing) {
        currentService = .init(service)
        PersistenceController
            .createInstance()
            .map { persistence in
                let repo = CoreDataShowsPaginationRepository(persistence: persistence)
                let cacheService = CachePolicyValidationShowsService(
                    service: service,
                    repo: repo,
                    cacheDurationInSeconds: 15 * 60
                )
                return cacheService as ShowsServicing
            }
            .tryCatch { error in
                switch error {
                case .dataModelNotFound:
                    // TODO: Log error
                    break
                case .persistentStoresLoadingFailed:
                    // TODO: Log error
                    break
                }
                return Fail<ShowsServicing, PersistenceControllerError>(error: error)
                    
            }
            .catch { _ in Just(service) }
            .assign(to: \.value, on: currentService)
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    // MARK: - ShowsServicing
    
    func shows(page: UInt) -> AnyPublisher<ShowsResult, any Error> {
        currentService
            .flatMap { service in
                service
                    .shows(page: page)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    func episodes(showId: Int) -> AnyPublisher<[Episode], any Error> {
        currentService
            .flatMap { service in
                service
                    .episodes(showId: showId)
                    .eraseToAnyPublisher()
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private
    
    private let currentService: CurrentValueSubject<ShowsServicing, Never>
    
    private var cancellables = Set<AnyCancellable>()
    
    
    
}
