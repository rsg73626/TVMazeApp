//
//  File.swift
//  ShowDetails
//
//  Created by Renan Germano on 05/09/25.
//

import Domain
import Foundation
@testable import ShowDetails

final class ShowDetailsPresentingMock: ShowDetailsPresenting {
    
    var view: ShowDetailsViewing?

    var updateImageCallCount = 0
    var updateShowsCallCount = 0
    
    var updateImageHandler: ((ImageState) -> Void)?
    var updateShowHandler: ((Show) -> Void)?
    
    // MARK: - ShowDetailsPresenting
    
    func update(imageState: ImageState) {
        updateImageCallCount += 1
        
        updateImageHandler?(imageState)
    }
    
    func update(show: Show) {
        updateShowsCallCount += 1
        updateShowHandler?(show)
    }
    
    
}
