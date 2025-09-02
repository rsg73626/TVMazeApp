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
    
    let dataFetcher: DataFetching
    
    init(dataFetcher: DataFetching) {
        self.dataFetcher = dataFetcher
    }
    
    // MARK: - ImageLoading
    
    func image(for show: Show) -> AnyPublisher<UIImage, Never> {
        let placeholder = Just(UIImage.placeholder).eraseToAnyPublisher()
        switch (show.image.medium, show.image.original) {
        case (.none, .none):
            return placeholder
        case (.some(let url), .none), (.none, .some(let url)):
            return fetch(url, onFailure: placeholder)
        case (.some(let medium), .some(let original)):
            let fetchOriginal = fetch(original, onFailure: placeholder)
            return fetch(medium, onFailure: fetchOriginal)
        }
    }
    
    // MARK: Private
    
    private func fetch(
        _ url: URL,
        onFailure: AnyPublisher<UIImage, Never>
    ) -> AnyPublisher<UIImage, Never> {
        dataFetcher
            .fetchData(for: url)
            .map { data in
                if let image = UIImage(data: data) {
                    Just(image).eraseToAnyPublisher()
                } else {
                    onFailure
                }
            }
            .switchToLatest()
            .catch { _ in onFailure }
            .eraseToAnyPublisher()
    }
    
}

fileprivate extension UIImage {
    static let placeholder = UIImage() // TODO: replace it with placeholder
}
