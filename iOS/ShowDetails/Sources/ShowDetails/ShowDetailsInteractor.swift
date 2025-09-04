// The Swift Programming Language
// https://docs.swift.org/swift-book

import Combine
import Domain
import ServiceAPI

final class ShowDetailsInteractor {
    
    let showsService: ShowsServicing
    
    init(showsService: ShowsServicing) {
        self.showsService = showsService
    }
    
}
