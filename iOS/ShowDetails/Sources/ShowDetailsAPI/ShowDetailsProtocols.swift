//
//  File.swift
//  ShowDetails
//
//  Created by Renan Germano on 04/09/25.
//

import Domain
import ServiceAPI
import UIKit

public struct ShowDetailsDependencies {
    
    public let dataFetcher: DataFetching
    public let imageService: ImageServicing
    public let showsService: ShowsServicing
    
    public init(
        dataFetcher: DataFetching,
        imageService: ImageServicing,
        showsService: ShowsServicing
    ) {
        self.dataFetcher = dataFetcher
        self.imageService = imageService
        self.showsService = showsService
    }
}

public protocol ShowDetailsBuilding {
    init(dependencies: ShowDetailsDependencies)
    
    func build(show: Show) -> UIViewController
}
