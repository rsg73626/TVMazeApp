
import Combine
import Domain
import Foundation
@testable import ShowDetails
import ShowDetailsAPI
import ServiceAPI
import ServiceAPIMocks
import UIKit
import XCTest

final class ShowDetailsTests: XCTestCase {
    
    private var presenter: ShowDetailsPresentingMock!
    private var service: ShowsServicingMock!
    private var imageLoader: ShowDetailsImageLoadingMock!
    private var textFormatter: TextFormattingMock!
    private var aShow: Show!
    private var interactor: ShowDetailsInteractor!
    
    override func setUp() {
        super.setUp()
        
        presenter = ShowDetailsPresentingMock()
        service = ShowsServicingMock()
        imageLoader = ShowDetailsImageLoadingMock()
        textFormatter = TextFormattingMock()
        aShow = show()
        interactor = ShowDetailsInteractor(
            show: aShow,
            showsService: service,
            imageLoader: imageLoader,
            textFormatter: textFormatter
        )
        interactor.presenter = presenter
        imageLoader.imageHandler = { receivedShow in
            XCTAssertIdentical(self.aShow, receivedShow)
            
            return PassthroughSubject<UIImage, Never>()
                .eraseToAnyPublisher()
        }
        textFormatter.summaryHandler = { receivedShow in
            XCTAssertIdentical(self.aShow, receivedShow)
            
            return AttributedString(stringLiteral: "test-summary")
        }
    }
    
    func test_viewDidLoad_showsLoading() {
        // given
        presenter.updateImageHandler = { value in
            XCTAssertEqual(.loading, value)
        }
        presenter.updateImageCallCount = 0
        
        // when
        interactor.viewDidLoad()
        
        // verify
        XCTAssertEqual(1, presenter.updateImageCallCount)
    }
    
    func test_viewDidLoad_callsImageLoader() {
        // given
        imageLoader.imageCallCount = 0
        
        // when
        interactor.viewDidLoad()
        
        // verify
        XCTAssertEqual(1, imageLoader.imageCallCount)
    }
    
    func test_viewDidLoad_imageLoaded_updagesImageOnPresenter() {
        // given
        let image = UIImage()
        let imageLoadingExp = expectation(description: "set image loading")
        let updateImageExp = expectation(description: "update image on presenter")
        imageLoader.imageHandler = { receivedShow in
            XCTAssertIdentical(self.aShow, receivedShow)
            
            return Just(image)
                .eraseToAnyPublisher()
        }
        presenter.updateImageHandler = { state in
            switch state {
            case .image(let receivedImage):
                XCTAssertIdentical(image, receivedImage)
                updateImageExp.fulfill()
            default:
                imageLoadingExp.fulfill()
            }
        }
        imageLoader.imageCallCount = 0
        presenter.updateImageCallCount = 0
        
        // when
        interactor.viewDidLoad()
        
        // verify
        wait(for: [imageLoadingExp, updateImageExp], timeout: 1, enforceOrder: true)
        XCTAssertEqual(1, imageLoader.imageCallCount)
        XCTAssertEqual(2, presenter.updateImageCallCount)
        
    }
    
    func test_viewDidLoad_updatesTitle() {
        // given
        presenter.updateTitleHandler = { receivedTitle in
            XCTAssertEqual(self.aShow.name, receivedTitle)
        }
        presenter.updateTitleCallCount = 0
        
        // when
        interactor.viewDidLoad()
        
        // verify
        XCTAssertEqual(1, presenter.updateTitleCallCount)
    }
    
    func test_viewDidLoad_showWithoutYearProperty_updatesYearWithNull() {
        // given
        updateSUT(show: show(year: nil))
        presenter.updateYearHandler = { receivedYear in
            XCTAssertNil(receivedYear)
        }
        presenter.updateYearCallCount = 0
        
        // when
        interactor.viewDidLoad()
        
        // verify
        XCTAssertEqual(1, presenter.updateYearCallCount)
    }
    
    func test_viewDidLoad_showWithYearProperty_updatesYearWithValue() {
        // given
        updateSUT(show: show(year: 2000))
        presenter.updateYearHandler = { receivedYear in
            XCTAssertEqual("2000", receivedYear)
        }
        presenter.updateYearCallCount = 0
        
        // when
        interactor.viewDidLoad()
        
        // verify
        XCTAssertEqual(1, presenter.updateYearCallCount)
    }
    
    func test_viewDidLoad_showWithEmptyGenresList_updatesGenresWithEmptyString() {
        // given
        updateSUT(show: show(genres: []))
        presenter.updateGenresHandler = { receivedGenres in
            XCTAssertEqual("", receivedGenres)
        }
        presenter.updateGenresCallCount = 0
        
        // when
        interactor.viewDidLoad()
        
        // verify
        XCTAssertEqual(1, presenter.updateGenresCallCount)
    }
    
    func test_viewDidLoad_showWithGenresProperty_updatesGenresWithValue() {
        // given
        let genres = ["Action", "Adventure", "Animation"]
        let expectedGenresValue = "Action, Adventure, Animation."
        updateSUT(show: show(genres: genres))
        presenter.updateGenresHandler = { receivedGenres in
            XCTAssertEqual(expectedGenresValue, receivedGenres)
        }
        presenter.updateGenresCallCount = 0
        
        // when
        interactor.viewDidLoad()
        
        // verify
        XCTAssertEqual(1, presenter.updateGenresCallCount)
    }
    
    func test_viewDidLoad_callsTextFormatter_updatesSummaryWithCorrectValue() {
        // given
        let expectedSummaryValue = AttributedString(stringLiteral: "test-summary")
        textFormatter.summaryHandler = { receivedShow in
            XCTAssertIdentical(self.aShow, receivedShow)
            return expectedSummaryValue
        }
        presenter.updateSummaryHandler = { receivedSummary in
            XCTAssertEqual(expectedSummaryValue, receivedSummary)
        }
        textFormatter.summaryCallCount = 0
        presenter.updateSummaryCallCount = 0
        
        // when
        interactor.viewDidLoad()
        
        // verify
        XCTAssertEqual(1, presenter.updateSummaryCallCount)
    }
    
    // MARK: - Private
    
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
    
    /**
     Updates the system under test (`ShowDetailsInteractor`) with the given instance of `Show`.
     */
    private func updateSUT(show: Show) {
        aShow = show
        interactor = ShowDetailsInteractor(
            show: aShow,
            showsService: service,
            imageLoader: imageLoader,
            textFormatter: textFormatter
        )
        interactor.presenter = presenter
    }
}
