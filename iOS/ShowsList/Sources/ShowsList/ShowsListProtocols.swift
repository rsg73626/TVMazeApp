//
//  File.swift
//  ShowsList
//
//  Created by Renan Germano on 08/09/25.
//

import Domain
import Foundation

protocol ShowsListRouting {
    func showDetails(for show: Show)
}

protocol ShowsListPresenting {
    func updateTitle()
    func update(loading: Bool)
    func update(shows: [Show])
    func update(loadingNewPage: Bool)
}

protocol ShowsListViewing {
    var listener: ShowsListViewingListening? { get set }
    
    func update(loading: Bool)
    func update(shows: [Show])
    func update(title: String)
    func update(loadingNewPage: Bool)
}

protocol ShowsListViewingListening: AnyObject {
    func viewDidLoad()
    func didSelect(show: Show)
    func didShowItemAt(index: Int)
    func didPressRetryButton()
}

protocol ShowViewProviding {
    @MainActor func showView(for show: Show, isGridLayout: Bool) -> ShowView
}
