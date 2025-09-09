
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
    private var aShow: Show!
    private var interactor: ShowDetailsInteractor!
    
    override func setUp() {
        super.setUp()
        
        presenter = ShowDetailsPresentingMock()
        service = ShowsServicingMock()
        imageLoader = ShowDetailsImageLoadingMock()
        aShow = show()
        interactor = ShowDetailsInteractor(
            presenter: presenter,
            show: aShow,
            showsService: service,
            imageLoader: imageLoader
        )
        interactor.presenter = presenter
        imageLoader.imageHandler = { receivedShow in
            XCTAssertIdentical(self.aShow, receivedShow)
            
            return PassthroughSubject<UIImage, Never>()
                .eraseToAnyPublisher()
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
    
    func test_viewDidLoad_imageLoaded_updatesImageOnPresenter() {
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
    
    func test_viewDidLoad_updatesShow() {
        // given
        presenter.updateShowHandler = { receivedShow in
            XCTAssertIdentical(self.aShow, receivedShow)
        }
        presenter.updateShowsCallCount = 0
        
        // when
        interactor.viewDidLoad()
        
        // verify
        XCTAssertEqual(1, presenter.updateShowsCallCount)
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
            presenter: presenter,
            show: aShow,
            showsService: service,
            imageLoader: imageLoader
        )
        interactor.presenter = presenter
    }
}
