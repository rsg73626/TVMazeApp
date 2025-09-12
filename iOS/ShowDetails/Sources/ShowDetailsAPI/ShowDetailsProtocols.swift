//
//  File.swift
//  ShowDetails
//
//  Created by Renan Germano on 04/09/25.
//

import Combine
import Domain
import UIKit

public protocol DataProviding {
    func fetchData(for url: URL) -> AnyPublisher<Data, Error>
}

public protocol ImageProviding {
    func images(showId: Int) -> AnyPublisher<[Image], Error>
}

public struct ShowDetailsDependencies {
    
    public let dataProvider: DataProviding
    public let imageProvider: ImageProviding
    
    public init(
        dataProvider: DataProviding,
        imageProvider: ImageProviding
    ) {
        self.dataProvider = dataProvider
        self.imageProvider = imageProvider
    }
}

public protocol ShowDetailsBuilding {
    init(dependencies: ShowDetailsDependencies)
    
    func build(show: Show) -> UIViewController
}
