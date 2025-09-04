//
//  File.swift
//  ShowsList
//
//  Created by Renan Germano on 04/09/25.
//

import Domain
@testable import ShowsList

final class ShowsListRoutingMock: ShowsListRouting {
    
    var showDetailsCallCount = 0
    
    var showDetailHandler: ((Show) -> Void)?
    
    init() { }
    
    func showDetails(for show: Show) {
        showDetailsCallCount += 1
        showDetailHandler?(show)
    }
}
