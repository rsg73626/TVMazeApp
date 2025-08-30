// The Swift Programming Language
// https://docs.swift.org/swift-book

import Combine
import Domain
import Foundation

public enum ShowsResult {
    case shows([Show])
    case didFinish
}

public protocol ShowsServicing {
    func shows(page: UInt) -> AnyPublisher<ShowsResult, Error>
    func episodes(showId: Int) -> AnyPublisher<[Episode], Error>
}
