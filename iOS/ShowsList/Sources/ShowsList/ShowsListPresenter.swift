//
//  File.swift
//  ShowsList
//
//  Created by Renan Germano on 08/09/25.
//

import Domain
import SwiftUI

final class ShowsListPresenter: ShowsListPresenting,
                                ShowViewProviding {
    
    var view: ShowsListViewing?
    
    init(
        title: String = "TVMaze",
        imageLoader: ImageLoading
    ) {
        self.title = title
        self.imageLoader = imageLoader
    }
    
    // MARK: - ShowsListPresenting
    
    func updateTitle() {
        view?.update(title: title)
    }
    
    func update(loading: Bool) {
        view?.update(loading: loading)
    }
    
    func update(shows: [Show]) {
        view?.update(shows: shows)
    }
    
    func update(loadingNewPage: Bool) {
        view?.update(loadingNewPage: loadingNewPage)
    }
    
    // MARK: - ShowViewProviding
    @MainActor
    func showView(for show: Show, isGridLayout: Bool) -> ShowView {
        ShowView(
            viewModel: ShowViewModel(
                show: show,
                imageLoader: imageLoader
            ),
            grid: isGridLayout
        )
    }
    
    // MARK: - Private
    
    private let title: String
    private let imageLoader: ImageLoading
    
}
