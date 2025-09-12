//
//  File.swift
//  ShowsList
//
//  Created by Renan Germano on 01/09/25.
//

import ShowsListAPI
import SwiftUI
import UIKit

public final class ShowsListBuilder: @preconcurrency ShowsListBuilding {
    
    let dependencies: ShowsListDependencies

    // MARK: - ShowsListBuilding
    
    public init(dependencies: ShowsListDependencies) {
        self.dependencies = dependencies
    }
    
    @MainActor public func build() -> UIViewController {
        let router = ShowsListRouter(showDetailsBuilder: dependencies.showDetailsBuilder)
        let presenter = ShowsListPresenter(imageLoader: imageLoader())
        let interactor = ShowsListInteractor(
            presenter: presenter,
            router: router,
            showsProvider: dependencies.showsProvider
        )
        var view = ShowsListView(showViewProvider: presenter)
        
        view.listener = interactor
        presenter.view = view
        
        let viewController = UIHostingController(rootView: view)
        router.viewController = viewController
        return viewController
    }
    
    // MARK: - Private
    
    private func imageLoader() -> ImageLoading {
        ImageLoader(dataProvider: dependencies.dataProvider)
    }

}
