// The Swift Programming Language
// https://docs.swift.org/swift-book

import Combine
import Domain
import Foundation
import ServiceAPI
import UIKit

protocol ShowDetailsPresentingListener {
    func viewDidLoad()
}

protocol ShowDetailsPresenting {
    func update(image: ImageState)
    func update(title: String)
    func update(year: String?)
    func update(genres: String)
    func update(summary: AttributedString)
}

final class ShowDetailsInteractor: ShowDetailsPresentingListener {
    
    var presenter: ShowDetailsPresenting?
    
    let show: Show
    let showsService: ShowsServicing
    let imageLoader: ShowDetailsImageLoading
    let textFormatter: TextFormatting
    
    init(
        show: Show,
        showsService: ShowsServicing,
        imageLoader: ShowDetailsImageLoading,
        textFormatter: TextFormatting = TextFormatter()
    ) {
        self.show = show
        self.showsService = showsService
        self.imageLoader = imageLoader
        self.textFormatter = textFormatter
    }
    
    // MARK: - ShowDetailsPresentingListener
    
    func viewDidLoad() {
        presenter?.update(image: .loading)
        imageLoader
            .image(for: show)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { _ in },
                receiveValue: { [weak self] image in
                    self?.presenter?.update(image: .image(image))
                }
            )
            .store(in: &cancellables)
        presenter?.update(title: show.name)
        if let year = show.year {
            presenter?.update(year: String(year))
        } else {
            presenter?.update(year: nil)
        }
        if !show.genres.isEmpty {
            presenter?.update(genres: show.genres.joined(separator: ", ") + ".")
        } else {
            presenter?.update(genres: "")
        }
        presenter?.update(summary: textFormatter.summary(for: show))
    }
    
    // MARK: - Private
    
    private var cancellables = Set<AnyCancellable>()
    
}
