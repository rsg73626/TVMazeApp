//
//  File.swift
//  ShowsList
//
//  Created by Renan Germano on 01/09/25.
//

import Combine
import Domain
import SwiftUI

protocol ShowViewModelFactoring {
    func build(show: Show) -> ShowViewModel
}

final class ShowViewModelFactory: ShowViewModelFactoring {
    
    let imageLoader: ImageLoading
    
    init(imageLoader: ImageLoading) {
        self.imageLoader = imageLoader
    }
    
    func build(show: Show) -> ShowViewModel {
        ShowViewModel(show: show, imageLoader: imageLoader)
    }

}

final class ShowViewModel: ObservableObject, Identifiable {
    let id: UUID
    @Published private(set) var name: String
    @Published private(set) var image: UIImage? = nil

    private var cancellables = Set<AnyCancellable>()

    init(show: Show, imageLoader: ImageLoading) {
        self.id = UUID()
        self.name = show.name

        imageLoader
            .image(for: show)
            .map { image -> UIImage? in .some(image) }
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
            .store(in: &cancellables)
    }
}
