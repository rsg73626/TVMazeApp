//
//  AppApp.swift
//  App
//
//  Created by Renan Germano on 30/08/25.
//

import ShowsList
import ShowsListAPI
import SwiftUI
import Service
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
    
    let navigationController = MainNavigation.mainNavigationController
    let dataFetcher = DataFetcher()
    let imageService = ImageService()
    let showsService = ShowsService()
    let builder = ShowsListBuilder()
    
    func makeUIViewController(context: Context) -> UINavigationController {
        let dependencies = (dataFetcher, imageService, showsService)
        let viewController = builder.build(dependencies: dependencies)
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
