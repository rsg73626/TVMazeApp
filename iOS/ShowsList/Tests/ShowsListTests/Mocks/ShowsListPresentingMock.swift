//
//  File.swift
//  ShowsList
//
//  Created by Renan Germano on 04/09/25.
//

import Domain
@testable import ShowsList

final class ShowsListPresentingMock: ShowsListPresenting {
    
    var updateTitleCallCount = 0
    var updateLoadingCallCount = 0
    var updateShowsCallCount = 0
    var updateLoadingNewPageCallCount = 0
    
    var updateTitleHandler: (() -> Void)?
    var updateLoadingHandler: ((Bool) -> Void)?
    var updateShowsHandler: (([Show]) -> Void)?
    var updateLoadingNewPageHandler: ((Bool) -> Void)?
    
    init() { }
    
    func updateTitle() {
        updateTitleCallCount += 1
        updateTitleHandler?()
    }

    func update(loading: Bool) {
        updateLoadingCallCount += 1
        updateLoadingHandler?(loading)
    }
    
    func update(shows: [Show]) {
        updateShowsCallCount += 1
        updateShowsHandler?(shows)
    }
    
    func update(loadingNewPage value: Bool) {
        updateLoadingNewPageCallCount += 1
        updateLoadingNewPageHandler?(value)
    }
    
}
