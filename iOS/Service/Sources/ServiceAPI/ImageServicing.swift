//
//  File.swift
//  Service
//
//  Created by Renan Germano on 30/08/25.
//

import Combine
import Domain
import Foundation

public protocol ImageServicing {
    func images(showId: Int) -> AnyPublisher<[Image], Error>
}
