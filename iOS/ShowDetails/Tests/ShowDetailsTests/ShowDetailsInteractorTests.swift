
import Combine
import Domain
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
        interactor = ShowDetailsInteractor(show: aShow, showsService: service, imageLoader: imageLoader)
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
    
    
    
    // MARK: - Private
    
    private func show() -> Show {
        Show(id: UUID().hashValue,
             name: "test-name",
             genres: ["test-genre-1",
                      "test-genre-2",
                      "test-genre-3"],
             summary: "test-summary",
             year: 2000,
             image: .init(
                medium: nil,
                original: nil)
        )
    }
}
