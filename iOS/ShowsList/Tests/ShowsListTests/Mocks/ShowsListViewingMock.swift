//
//  File.swift
//  ShowsList
//
//  Created by Renan Germano on 11/09/25.
//

import Domain
@testable import ShowsList

final class ShowsListViewingMock: ShowsListViewing {
    
    var updateLoadingCallCount = 0
    var updateShowsCallCount = 0
    var updateTitleCallCount = 0
    var updateLoadingNewPageCallCount = 0
    
    var updateLoadingHandler: ((Bool) -> Void)?
    var updateShowsHandler: (([Show]) -> Void)?
    var updateTitleHandler: ((String) -> Void)?
    var updateLoadingNewPageHandler: ((Bool) -> Void)?
    
    // MAKR: - ShowsListViewing
    
    var listener: ShowsListViewingListening?
    
    func update(loading: Bool) {
        updateLoadingCallCount += 1
        
        updateLoadingHandler?(loading)
    }
    
    func update(shows: [Show]) {
        updateShowsCallCount += 1
        
        updateShowsHandler?(shows)
    }
    
    func update(title: String) {
        updateTitleCallCount += 1
        
        updateTitleHandler?(title)
    }
    
    func update(loadingNewPage: Bool) {
        updateLoadingNewPageCallCount += 1
        
        updateLoadingNewPageHandler?(loadingNewPage)
    }
    
    
}
