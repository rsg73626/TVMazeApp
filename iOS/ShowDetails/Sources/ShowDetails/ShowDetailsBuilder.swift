//
//  File.swift
//  ShowDetails
//
//  Created by Renan Germano on 04/09/25.
//

import Domain
import ShowDetailsAPI
import SwiftUI

public final class ShowDetailsBuilder: @preconcurrency ShowDetailsBuilding {
    
    private let dependencies: ShowDetailsDependencies
    
    // MARK: - ShowDetailsBuilding
    
    public init(dependencies: ShowDetailsDependencies) {
        self.dependencies = dependencies
    }
    
    @MainActor public func build(show: Show) -> UIViewController {
        let imageLoader = ShowDetailsImageLoader(
            imageService: dependencies.imageService,
            dataFetcher: dependencies.dataFetcher
        )
        let interactor = ShowDetailsInteractor(
            show: show,
            showsService: dependencies.showsService,
            imageLoader: imageLoader
        )
        var view = ShowDetailsView()
        view.listener = interactor
        interactor.presenter = view
        return UIHostingController(rootView: view)
    }

}
