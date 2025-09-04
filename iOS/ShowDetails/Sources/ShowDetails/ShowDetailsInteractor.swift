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
    
    init(
        show: Show,
        showsService: ShowsServicing,
        imageLoader: ShowDetailsImageLoading
    ) {
        self.show = show
        self.showsService = showsService
        self.imageLoader = imageLoader
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
        presenter?.update(genres: show.genres.joined(separator: ", ") + ".")
        presenter?.update(summary: .init(html: show.summary)?.removingFonts() ?? .init(""))
    }
    
    // MARK: - Private
    
    private var cancellables = Set<AnyCancellable>()
    
}

extension AttributedString {
    
    init?(html: String) {
        let htmlBase = """
        <style>
        body { font: -apple-system-body; font-size: 17px; }
        p { margin: 0 0 8px; }
        </style>
        """
        let html = htmlBase + html
        guard let data = html.data(using: .utf8) else { return nil }
        do {
            let ns = try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            self = AttributedString(ns)
        } catch {
            return nil
        }
    }
    
    func removingFonts() -> AttributedString {
        var copy = self
        for run in copy.runs {
            if run.attributes.font != nil {
                copy[run.range].font = nil
            }
        }
        return copy
    }
}
