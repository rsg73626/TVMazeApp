//
//  File.swift
//  Service
//
//  Created by Renan Germano on 30/08/25.
//

import Combine
import Foundation
import ServiceAPI

public final class DataFetcher: DataFetching {

    let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - DataFetching
    
    public func fetchData(for url: URL) -> AnyPublisher<Data, Error> {
        session
            .dataTaskPublisher(for: url)
            .tryMap { data, _ in data }
            .eraseToAnyPublisher()
    }
    
}
