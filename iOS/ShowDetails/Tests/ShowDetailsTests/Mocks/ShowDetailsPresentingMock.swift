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
    
    var updateImageCallCount = 0
    var updateTitleCallCount = 0
    var updateYearCallCount = 0
    var updateGenresCallCount = 0
    var updateSummaryCallCount = 0
    
    var updateImageHandler: ((ImageState) -> Void)?
    var updateTitleHandler: ((String) -> Void)?
    var updateYearHandler: ((String?) -> Void)?
    var updateGenresHandler: ((String) -> Void)?
    var updateSummaryHandler: ((AttributedString) -> Void)?
    
    // MARK: - ShowDetailsPresenting
    
    func update(image: ImageState) {
        updateImageCallCount += 1
        
        updateImageHandler?(image)
    }
    
    func update(title: String) {
        updateTitleCallCount += 1
        
        updateTitleHandler?(title)
    }
    
    func update(year: String?) {
        updateYearCallCount += 1
        
        updateYearHandler?(year)
    }
    
    func update(genres: String) {
        updateGenresCallCount += 1
        
        updateGenresHandler?(genres)
    }
    
    func update(summary: AttributedString) {
        updateSummaryCallCount += 1
        
        updateSummaryHandler?(summary)
    }
    
    
}
