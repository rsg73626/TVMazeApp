//
//  File.swift
//  ShowDetails
//
//  Created by Renan Germano on 09/09/25.
//

import Domain
@testable import ShowDetails
import XCTest

final class ShowDetailsPresenterTests: XCTestCase {
    
    private var aShow: Show!
    private var textFormatter: TextFormattingMock!
    private var view: ShowDetailsViewingMock!
    private var presenter: ShowDetailsPresenter!
    
    override func setUp() {
        super.setUp()
        
        self.aShow = show()
        textFormatter = TextFormattingMock()
        view = ShowDetailsViewingMock()
        presenter = ShowDetailsPresenter(textFormatter: textFormatter)
        
        presenter.view = view
        
        textFormatter.summaryHandler = { receivedShow in
            XCTAssertIdentical(self.aShow, receivedShow)
            return .init(stringLiteral: "test-summary")
        }
    }
    
    func test_updateShow_updatesView() {
        // given
        let genres = ["Action", "Adventure", "Animation"]
        let expectedGenresValue = "Action, Adventure, Animation."
        let expectedSummaryValue = AttributedString(stringLiteral: aShow.summary)
        self.aShow = show(genres: genres)
        view.updateYearHandler = { receivedYear in
            XCTAssertEqual("\(self.aShow.year!)", receivedYear)
        }
        view.updateTitleHandler = { receivedTitle in
            XCTAssertEqual(self.aShow.name, receivedTitle)
        }
        view.updateGenresHandler = { receivedGenres in
            XCTAssertEqual(expectedGenresValue, receivedGenres)
        }
        view.updateSummaryHandler = { receivedSummary in
            XCTAssertEqual(expectedSummaryValue, receivedSummary)
        }
        view.updateYearCallCount = 0
        view.updateTitleCallCount = 0
        view.updateGenresCallCount = 0
        view.updateSummaryCallCount = 0
        textFormatter.summaryCallCount = 0
        
        // when
        presenter.update(show: aShow)
        
        // verify
        XCTAssertEqual(1, view.updateYearCallCount)
        XCTAssertEqual(1, view.updateTitleCallCount)
        XCTAssertEqual(1, view.updateGenresCallCount)
        XCTAssertEqual(1, view.updateSummaryCallCount)
        XCTAssertEqual(1, textFormatter.summaryCallCount)
    }
    
    func test_updateImageState_loading_callsView_updateImageState() {
        // given
        view.updateImageStateHandler = { receivedImageState in
            XCTAssertEqual(.loading, receivedImageState)
        }
        view.updateImageStateCallCount = 0
        
        // when
        presenter.update(imageState: .loading)
        
        // verify
        XCTAssertEqual(1, view.updateImageStateCallCount)
    }
    
    func test_updateImageState_image_callsView_updateImageState() {
        // given
        let aImage = UIImage()
        view.updateImageStateHandler = { receivedImageState in
            XCTAssertEqual(.image(aImage), receivedImageState)
        }
        view.updateImageStateCallCount = 0
        
        // when
        presenter.update(imageState: .image(aImage))
        
        // verify
        XCTAssertEqual(1, view.updateImageStateCallCount)
    }
    
    func test_updateShow_emptyGenres_nullYear_updatesViewCorrectly() {
        // given
        self.aShow = show(genres: [], year: nil)
        view.updateGenresHandler = { receivedGenres in
            XCTAssertTrue(receivedGenres.isEmpty)
        }
        view.updateYearHandler = { receivedYear in
            XCTAssertNil(receivedYear)
        }
        view.updateGenresCallCount = 0
        view.updateYearCallCount = 0
        
        // when
        presenter.update(show: aShow)
        
        // verify
        XCTAssertEqual(1, view.updateGenresCallCount)
        XCTAssertEqual(1, view.updateYearCallCount)
    }

    // MARK: - Helpers
    
    private func show(
        genres: [String] = [
            "test-genre-1",
            "test-genre-2",
            "test-genre-3"
        ],
        year: Int? = 2000
    ) -> Show {
        Show(id: UUID().hashValue,
             name: "test-name",
             genres: genres,
             summary: "test-summary",
             year: year,
             image: .init(
                medium: nil,
                original: nil)
        )
    }
    
}
