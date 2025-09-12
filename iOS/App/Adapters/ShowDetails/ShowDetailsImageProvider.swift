//
//  ShowDetailsImageProvider.swift
//  App
//
//  Created by Renan Germano on 12/09/25.
//

import Combine
import Domain
import ShowDetailsAPI
import ServiceAPI

final class ShowDetailsImageProvider: ShowDetailsAPI.ImageProviding {
    
    init(imageService: ServiceAPI.ImageServicing) {
        self.imageService = imageService
    }
    
    // MARK: - ImageProviding
    
    func images(showId: Int) -> AnyPublisher<[Image], any Error> {
        imageService
            .images(showId: showId)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private
    
    private let imageService: ServiceAPI.ImageServicing
    
    
}
