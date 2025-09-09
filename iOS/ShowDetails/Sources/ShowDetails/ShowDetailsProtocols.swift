//
//  File.swift
//  ShowDetails
//
//  Created by Renan Germano on 09/09/25.
//

import Domain
import Foundation
import SwiftUI

protocol ShowDetailsPresentingListener {
    func viewDidLoad()
}

protocol ShowDetailsPresenting {
    var view: ShowDetailsViewing? { get set }
    
    func update(imageState: ImageState)
    func update(show: Show)
}

protocol ShowDetailsViewing {
    func update(imageState: ImageState)
    func update(title: String)
    func update(genres: String)
    func update(year: String?)
    func update(summary: AttributedString)
}

enum ImageState: Equatable {
    case loading
    case image(UIImage)
    
    var isLoading: Bool { self == .loading }
}
