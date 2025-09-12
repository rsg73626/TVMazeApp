//
//  File.swift
//  ShowsList
//
//  Created by Renan Germano on 11/09/25.
//

import Combine
import Domain
@testable import ShowsList
import SwiftUI
import XCTest

final class ShowsListPresenterTests: XCTestCase {
    
    private let title = "test-title"
    private var imageLoader: ShowsListImageLoadingMock!
    private var view: ShowsListViewingMock!
    private var presenter: ShowsListPresenter!
    private var aShow = Show(
        id: 1,
        name: "test",
        genres: [],
        summary: "test",
        year: nil,
        image: .init(
            medium: nil,
            original: nil
        )
    )
    
    override func setUp() {
        super.setUp()
        
        imageLoader = ShowsListImageLoadingMock()
        view = ShowsListViewingMock()
        presenter = ShowsListPresenter(title: title, imageLoader: imageLoader)
        presenter.view = view
    }
    
    func test_updateTitle_updatesTitleInView() {
        // given
        view.updateTitleHandler = { receivedTitle in
            XCTAssertEqual(self.title, receivedTitle)
        }
        view.updateTitleCallCount = 0
        
        // when
        presenter.updateTitle()
        
        // verify
        XCTAssertEqual(1, view.updateTitleCallCount)
    }
    
    func test_updateLoading_trueValue_updatesLoadingInView() {
        // given
        view.updateLoadingHandler = { receivedValue in
            XCTAssertTrue(receivedValue)
        }
        view.updateLoadingCallCount = 0
        
        // when
        presenter.update(loading: true)
        
        // verify
        XCTAssertEqual(1, view.updateLoadingCallCount)
    }
    
    func test_updateLoading_falseValue_updatesLoadingInView() {
        // given
        view.updateLoadingHandler = { receivedValue in
            XCTAssertFalse(receivedValue)
        }
        view.updateLoadingCallCount = 0
        
        // when
        presenter.update(loading: false)
        
        // verify
        XCTAssertEqual(1, view.updateLoadingCallCount)
    }
    
    func test_updateShows_updatesShowsInView() {
        // given
        let shows: [Show] = [ aShow ]
        view.updateShowsHandler = { receivedShows in
            XCTAssertEqual(shows, receivedShows)
        }
        view.updateShowsCallCount = 0
        
        // when
        presenter.update(shows: shows)
        
        // verify
        XCTAssertEqual(1, view.updateShowsCallCount)
    }
    
    func test_updateLoadingNew_trueValue_updatesLoadingNewPageInView() {
        // given
        view.updateLoadingNewPageHandler = { receivedValue in
            XCTAssertTrue(receivedValue)
        }
        view.updateLoadingNewPageCallCount = 0
        
        // when
        presenter.update(loadingNewPage: true)
        
        // verify
        XCTAssertEqual(1, view.updateLoadingNewPageCallCount)
    }
    
    func test_updateLoadingNew_falseValue_updatesLoadingNewPageInView() {
        // given
        view.updateLoadingNewPageHandler = { receivedValue in
            XCTAssertFalse(receivedValue)
        }
        view.updateLoadingNewPageCallCount = 0
        
        // when
        presenter.update(loadingNewPage: false)
        
        // verify
        XCTAssertEqual(1, view.updateLoadingNewPageCallCount)
    }
    
    @MainActor func test_showView_returnsViewInstance_startsLoadingImage() {
        // given
        imageLoader.imageHandler = { receivedShow in
            XCTAssertIdentical(self.aShow, receivedShow)
            return PassthroughSubject<UIImage, Never>()
                .eraseToAnyPublisher()
        }
        imageLoader.imageCallCount = 0
        
        // when
        _ = presenter.showView(for: aShow, isGridLayout: true)
        
        // verify
        XCTAssertEqual(1, imageLoader.imageCallCount)
    }
    
}
