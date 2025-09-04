//
//  File.swift
//  ShowsList
//
//  Created by Renan Germano on 04/09/25.
//

import Domain
@testable import ShowsList

final class ShowsListPresentingMock: ShowsListPresenting {
    
    var showLoadingCallCount = 0
    var hideLoadingCallCount = 0
    var updateListCallCount = 0
    var updateTitleCallCount = 0
    var updateLoadingNewPageCallCount = 0
    
    var showLoadingHandler: (() -> Void)?
    var hideLoadingHandler: (() -> Void)?
    var updateListHandler: (([Show]) -> Void)?
    var updateTitleHandler: ((String) -> Void)?
    var updateLoadingNewPageHandler: ((Bool) -> Void)?
    
    init() { }

    func showLoading() {
        showLoadingCallCount += 1
        showLoadingHandler?()
    }
    
    func hideLoading() {
        hideLoadingCallCount += 1
        hideLoadingHandler?()
    }
    
    func update(list: [Show]) {
        updateListCallCount += 1
        updateListHandler?(list)
    }
    
    func update(title: String) {
        updateTitleCallCount += 1
        updateTitleHandler?(title)
    }
    
    func update(loadingNewPage value: Bool) {
        updateLoadingNewPageCallCount += 1
        updateLoadingNewPageHandler?(value)
    }
    
}
