//
//  AppApp.swift
//  App
//
//  Created by Renan Germano on 30/08/25.
//

import ShowDetails
import ShowDetailsAPI
import ShowsList
import ShowsListAPI
import SwiftUI
import Service
import ServiceAPI
import UIKit

@main
struct AppApp: App {
    
    var body: some Scene {
        WindowGroup {
            NavigationViewWrapper()
        }
    }
}

fileprivate struct NavigationViewWrapper: UIViewControllerRepresentable {
    
    var navigationController = MainNavigation.mainNavigationController
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let viewController = DI.showsListBuilder.build()
        navigationController.setViewControllers([viewController], animated: false)
        navigationController.navigationBar.barStyle = .default
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.isTranslucent = false
        return navigationController
    }
    
    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
    
}

final class MainNavigation {
    
    static let mainNavigationController = UINavigationController()
    
    private init() { }
    
}

final class DI {

    private static let dataFetcher = DataFetcher()
    private static let imageService = ImageService()
    
    private static var showsService: ShowsServicing = {
        let service = ShowsService()
        let retry = RetryShowsService(service: service)
        let local = LocalShowsService(service: retry)
        return local
    }()
    
    private static var showDetailsBuilder: ShowDetailsBuilding = {
        let dependencies = ShowDetailsDependencies(
            dataFetcher: dataFetcher,
            imageService: imageService,
            showsService: showsService
        )
        return ShowDetailsBuilder(dependencies: dependencies)
    }()
    
    static var showsListBuilder: ShowsListBuilding = {
        let dependencies = ShowsListDependencies(
            dataFetcher: dataFetcher,
            imageService: imageService,
            showsService: showsService,
            showDetailsBuilder: showDetailsBuilder
        )
        return ShowsListBuilder(dependencies: dependencies)
    }()
    
    private init() { }
    
}
