//
//  File.swift
//  ShowDetails
//
//  Created by Renan Germano on 04/09/25.
//

import Combine
import Domain
import ServiceAPI
import UIKit

protocol ShowDetailsImageLoading {
    func image(for show: Show) -> AnyPublisher<UIImage, Never>
}

final class ShowDetailsImageLoader: ShowDetailsImageLoading {
    
    let imageService: ImageServicing
    let dataFetcher: DataFetching
    
    init(
        imageService: ImageServicing,
        dataFetcher: DataFetching
    ) {
        self.imageService = imageService
        self.dataFetcher = dataFetcher
    }
    
    // MARK: - ShowDetailsImageLoading
    
    func image(for show: Show) -> AnyPublisher<UIImage, Never> {
        return imageService
            .images(showId: show.id)
            .replaceError(with: [])
            .map { images -> (mainPoster: URL?, poster: URL?) in
                let firstMainPoster = images.first { $0.main && $0.poster }?.url
                let firstPoster = images.first { $0.poster }?.url
                return (firstMainPoster, firstPoster)
            }
            .flatMap { [fetch] mainPoster, poster -> AnyPublisher<UIImage, Never> in
                let placeholder = Just(UIImage.placeholder).eraseToAnyPublisher()
                switch (mainPoster, poster) {
                case (.none, .none):
                    return placeholder
                case (.some(let url), .none), (.none, .some(let url)):
                    return fetch(url, placeholder)
                case (.some(let mainPoster), .some(let poster)):
                    let fetchPoster = fetch(poster, placeholder)
                    return fetch(mainPoster, fetchPoster)
                }
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - private
    
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
