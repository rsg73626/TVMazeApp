//
//  ShowDetailsDataProvider.swift
//  App
//
//  Created by Renan Germano on 12/09/25.
//

import Combine
import Domain
import Foundation
import ServiceAPI
import ShowDetailsAPI

final class ShowDetailsDataProvider: ShowDetailsAPI.DataProviding {
    
    init(dataFetcher: ServiceAPI.DataFetching) {
        self.dataFetcher = dataFetcher
    }
    
    // MARK: - DataProviding
    
    func fetchData(for url: URL) -> AnyPublisher<Data, any Error> {
        dataFetcher
            .fetchData(for: url)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private
    
    private let dataFetcher: ServiceAPI.DataFetching
    
}
