//
//  File.swift
//  ShowsList
//
//  Created by Renan Germano on 01/09/25.
//

import Domain
import ShowsListAPI
import UIKit

public protocol ShowsListRouting {
    func showDetails(for: Show)
}

final class ShowsListRouter: ShowsListRouting {
    
    weak var viewController: UIViewController?
    
    // MARK: ShowsListRouting
    
    func showDetails(for: Show) {
        // TODO: navigate to show details
    }
}
