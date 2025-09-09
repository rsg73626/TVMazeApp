//
//  File.swift
//  ShowDetails
//
//  Created by Renan Germano on 09/09/25.
//

import Foundation
@testable import ShowDetails

final class ShowDetailsViewingMock: ShowDetailsViewing {
    
    var updateImageStateCallCount = 0
    var updateTitleCallCount = 0
    var updateGenresCallCount = 0
    var updateYearCallCount = 0
    var updateSummaryCallCount = 0
    
    var updateImageStateHandler: ((ImageState) -> Void)?
    var updateTitleHandler: ((String) -> Void)?
    var updateGenresHandler: ((String) -> Void)?
    var updateYearHandler: ((String?) -> Void)?
    var updateSummaryHandler: ((AttributedString) -> Void)?
    
    // MARK: - ShowDetailsViewing
    
    func update(imageState: ImageState) {
        updateImageStateCallCount += 1
        
        updateImageStateHandler?(imageState)
    }
    
    func update(title: String) {
        updateTitleCallCount += 1
        
        updateTitleHandler?(title)
    }
    
    func update(genres: String) {
        updateGenresCallCount += 1
        
        updateGenresHandler?(genres)
    }
    
    func update(year: String?) {
        updateYearCallCount += 1
        
        updateYearHandler?(year)
    }
    
    func update(summary: AttributedString) {
        updateSummaryCallCount += 1
        
        updateSummaryHandler?(summary)
    }
    
    
}
