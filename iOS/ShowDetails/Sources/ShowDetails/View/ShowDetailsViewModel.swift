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

enum ImageState: Equatable {
    case loading
    case image(UIImage)
    
    var isLoading: Bool { self == .loading }
}

final class ShowDetailsViewModel: ObservableObject, Identifiable {
    let id: UUID
    @Published var image: ImageState
    @Published var title: String
    @Published var genres: String
    @Published var year: String?
    @Published var summary: AttributedString
    
    init(
        image: ImageState = .loading,
        title: String = "",
        genres: String = "",
        year: String? = nil,
        summary: AttributedString = .init("")
    ) {
        self.id = UUID()
        self.image = image
        self.title = title
        self.genres = genres
        self.year = year
        self.summary = summary
    }
}
