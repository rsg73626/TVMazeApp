//
//  File.swift
//  ShowDetails
//
//  Created by Renan Germano on 09/09/25.
//

import Domain
import Foundation
import SwiftUI

final class ShowDetailsPresenter: ShowDetailsPresenting {
    
    let textFormatter: TextFormatting
    
    init(textFormatter: TextFormatting = TextFormatter()) {
        self.textFormatter = textFormatter
    }
    
    // MARK: - ShowDetailsPresenting
    
    var view: ShowDetailsViewing?
    
    func update(imageState: ImageState) {
        view?.update(imageState: imageState)
    }
    
    func update(show: Show) {
        view?.update(title: show.name)
        if let year = show.year {
            view?.update(year: String(year))
        } else {
            view?.update(year: nil)
        }
        if !show.genres.isEmpty {
            view?.update(genres: show.genres.joined(separator: ", ") + ".")
        } else {
            view?.update(genres: "")
        }
        view?.update(summary: textFormatter.summary(for: show))
    }
    
}

fileprivate extension UIImage {
    static let placeholder = UIImage()
}
