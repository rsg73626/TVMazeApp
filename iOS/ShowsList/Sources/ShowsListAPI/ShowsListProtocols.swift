//
//  File.swift
//  ShowsList
//
//  Created by Renan Germano on 30/08/25.
//

import Combine
import Domain
import ShowDetailsAPI
import UIKit

public enum ShowsResult {
    case shows([Show])
    case didFinish
}

public protocol ShowsProviding {
    func shows(page: UInt) -> AnyPublisher<ShowsResult, Error>
}

public protocol DataProviding {
    func data(for url: URL) -> AnyPublisher<Data, Error>
}

public struct ShowsListDependencies {
    
    public let showsProvider: ShowsProviding
    public let dataProvider: DataProviding
    public let showDetailsBuilder: ShowDetailsBuilding
    
    init(
        showsProvider: ShowsProviding,
        dataProvider: DataProviding,
        showDetailsBuilder: ShowDetailsBuilding
    ) {
        self.showsProvider = showsProvider
        self.dataProvider = dataProvider
        self.showDetailsBuilder = showDetailsBuilder
    }
}

public protocol ShowsListBuilding {
    init(dependencies: ShowsListDependencies)
    
    func build() -> UIViewController
}
