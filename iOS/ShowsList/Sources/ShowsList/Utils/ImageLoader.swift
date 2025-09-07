//
//  File.swift
//  ShowsList
//
//  Created by Renan Germano on 01/09/25.
//

import Combine
import Domain
import ServiceAPI
import UIKit

protocol ImageLoading {
    func image(for show: Show) -> AnyPublisher<UIImage, Never>
}

final class ImageLoader: ImageLoading {
    
    var dataToImage: (Data) -> UIImage? = UIImage.init
    let dataFetcher: DataFetching
    let defaultPlaceholder: UIImage
    
    init(
        dataFetcher: DataFetching,
        defaultPlaceholder: UIImage = .placeholder
    ) {
        self.dataFetcher = dataFetcher
        self.defaultPlaceholder = defaultPlaceholder
    }
    
    // MARK: - ImageLoading
    
    func image(for show: Show) -> AnyPublisher<UIImage, Never> {
        switch (show.image.medium, show.image.original) {
        case (.none, .none):
            return placeholder
        case (.some(let url), .none), (.none, .some(let url)):
            return fetch(url, onFailure: self.placeholder)
        case (.some(let medium), .some(let original)):
            return fetch(medium, onFailure: self.fetch(original, onFailure: self.placeholder))
        }
    }
    
    // MARK: Private
    
    private var placeholder: AnyPublisher<UIImage, Never> {
        Just(defaultPlaceholder)
            .eraseToAnyPublisher()
    }
    
    private func fetch(
        _ url: URL,
        onFailure: @escaping @autoclosure () -> AnyPublisher<UIImage, Never>
    ) -> AnyPublisher<UIImage, Never> {
        dataFetcher
            .fetchData(for: url)
            .map { [dataToImage] data in
                if let image = dataToImage(data) {
                    Just(image)
                        .eraseToAnyPublisher()
                } else {
                    onFailure()
                }
            }
            .switchToLatest()
            .catch { _ in
                onFailure()
            }
            .eraseToAnyPublisher()
    }
    
}

fileprivate extension UIImage {
    static let placeholder = UIImage() // TODO: replace it with placeholder
}
