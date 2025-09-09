//
//  File.swift
//  ShowsList
//
//  Created by Renan Germano on 01/09/25.
//

import Domain
import ShowDetailsAPI
import ShowsListAPI
import UIKit

final class ShowsListRouter: @preconcurrency ShowsListRouting {
    
    weak var viewController: UIViewController?
    
    let showDetailsBuilder: ShowDetailsBuilding
    
    init(showDetailsBuilder: ShowDetailsBuilding) {
        self.showDetailsBuilder = showDetailsBuilder
    }
    
    // MARK: ShowsListRouting
    
    @MainActor func showDetails(for show: Show) {
        viewController?.navigationController?.pushViewController(
            showDetailsBuilder.build(show: show),
            animated: true
        )
    }
}
