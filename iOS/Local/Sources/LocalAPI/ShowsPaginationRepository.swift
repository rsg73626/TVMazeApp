//
//  File.swift
//  Local
//
//  Created by Renan Germano on 02/09/25.
//

import Combine
import Domain

public protocol ShowsPaginationRepository {
    func add(id: String, shows: [Show], timestamp: Double) -> AnyPublisher<Void, Error>
    func delete(id: String) -> AnyPublisher<Void, Error>
    func pagination(id: String) -> AnyPublisher<(shows: [Show], timeStamp: Double), Error>
    func update(id: String, timestamp: Double) -> AnyPublisher<Void, Error>
}
