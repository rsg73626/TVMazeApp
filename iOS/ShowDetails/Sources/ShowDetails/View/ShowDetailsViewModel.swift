//
//  File.swift
//  ShowDetails
//
//  Created by Renan Germano on 04/09/25.
//

import Combine
import Domain
import Foundation
import SwiftUI

protocol ShowDetailsViewModelFactoring {
    func build(show: Show) -> ShowDetailsViewModel
}

final class ShowDetailsViewModelFactory: ShowDetailsViewModelFactoring {
    
    let imageLoader: ShowDetailsImageLoading
    
    init(imageLoader: ShowDetailsImageLoading) {
        self.imageLoader = imageLoader
    }
    
    func build(show: Show) -> ShowDetailsViewModel {
        ShowDetailsViewModel(show: show, imageLoader: imageLoader)
    }

}

final class ShowDetailsViewModel: ObservableObject, Identifiable {
    let id: UUID
    @Published private(set) var name: String
    @Published private(set) var genres: String
    @Published private(set) var year: String?
    @Published private(set) var summary: AttributedString
    @Published private(set) var image: UIImage? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        show: Show,
        imageLoader: ShowDetailsImageLoading
    ) {
        self.id = UUID()
        self.name = show.name
        self.summary = .init(html: show.summary)?.removingFonts() ?? ""
        self.genres = show.genres.joined(separator: ", ") + "."
        if let year = show.year {
            self.year = String(year)
        } else {
            self.year = nil
        }
        
        imageLoader
            .image(for: show)
            .map { image -> UIImage? in .some(image) }
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
            .store(in: &cancellables)
    }
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
