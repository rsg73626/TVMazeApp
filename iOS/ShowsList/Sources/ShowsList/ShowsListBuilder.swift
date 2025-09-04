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
        let imageLoader = ImageLoader(dataFetcher: dependencies.dataFetcher)
        let factory = ShowViewModelFactory(imageLoader: imageLoader)
        let title = "TVMaze" // TODO: Use localized strings
        var view = ShowsListView(title: title, shows: [], showViewModelFactory: factory)
        let router = ShowsListRouter(showDetailsBuilder: dependencies.showDetailsBuilder)
        let interactor = ShowsListInteractor(
            router: router,
            showsService: dependencies.showsService
        )
        view.listener = interactor
        interactor.presenter = view
        let viewController = UIHostingController(rootView: view)
        router.viewController = viewController
        return viewController
    }

}
