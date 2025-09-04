//
//  File.swift
//  ShowsList
//
//  Created by Renan Germano on 30/08/25.
//

import Domain
import ServiceAPI
import ShowDetailsAPI
import UIKit

public struct ShowsListDependencies {
    
    public let dataFetcher: DataFetching
    public let imageService: ImageServicing
    public let showsService: ShowsServicing
    public let showDetailsBuilder: ShowDetailsBuilding
    
    public init(dataFetcher: DataFetching, imageService: ImageServicing, showsService: ShowsServicing, showDetailsBuilder: ShowDetailsBuilding) {
        self.dataFetcher = dataFetcher
        self.imageService = imageService
        self.showsService = showsService
        self.showDetailsBuilder = showDetailsBuilder
    }
}

public protocol ShowsListBuilding {
    init(dependencies: ShowsListDependencies)
    
    func build() -> UIViewController
}
