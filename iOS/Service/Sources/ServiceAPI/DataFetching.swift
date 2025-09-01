//
//  File.swift
//  Service
//
//  Created by Renan Germano on 30/08/25.
//

import Combine
import Foundation

public protocol DataFetching {
    func fetchData(for url: URL) -> AnyPublisher<Data, Error>
}
