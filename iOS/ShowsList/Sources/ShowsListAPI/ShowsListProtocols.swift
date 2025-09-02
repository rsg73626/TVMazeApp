//
//  File.swift
//  ShowsList
//
//  Created by Renan Germano on 30/08/25.
//

import Domain
import ServiceAPI
import UIKit

public typealias ShowsListDependencies = (
    dataFetcher: DataFetching,
    imageService: ImageServicing,
    showsService: ShowsServicing
)

public protocol ShowsListBuilding {
    func build(dependencies: ShowsListDependencies) -> UIViewController
}
