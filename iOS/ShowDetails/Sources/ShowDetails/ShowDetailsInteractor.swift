// The Swift Programming Language
// https://docs.swift.org/swift-book

import Combine
import Domain
import Foundation
import ServiceAPI
import UIKit

final class ShowDetailsInteractor: ShowDetailsPresentingListener {
    
    var presenter: ShowDetailsPresenting
    let show: Show
    let showsService: ShowsServicing
    let imageLoader: ShowDetailsImageLoading
    
    init(
        presenter: ShowDetailsPresenting,
        show: Show,
        showsService: ShowsServicing,
        imageLoader: ShowDetailsImageLoading
    ) {
        self.presenter = presenter
        self.show = show
        self.showsService = showsService
        self.imageLoader = imageLoader
    }
    
    // MARK: - ShowDetailsPresentingListener
    
    func viewDidLoad() {
        presenter.update(imageState: .loading)
        presenter.update(show: show)
        imageLoader
            .image(for: show)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] image in
                    self?.presenter.update(imageState: .image(image))
                }
            )
            .store(in: &cancellables)
    }
    
    // MARK: - Private
    
    private var cancellables = Set<AnyCancellable>()
    
}
