//
//  ShowsListDataProvider.swift
//  App
//
//  Created by Renan Germano on 12/09/25.
//

import Combine
import Foundation
import ServiceAPI
import ShowsListAPI

final class ShowsListDataProvider: ShowsListAPI.DataProviding {
    
    init(dataFetcher: DataFetching) {
        self.dataFetcher = dataFetcher
    }
    
    // MARK: - DataProviding
    
    func data(for url: URL) -> AnyPublisher<Data, any Error> {
        dataFetcher
            .fetchData(for: url)
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private
    
    let dataFetcher: DataFetching
    
    
}
