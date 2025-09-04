
import Combine
import Domain
@testable import ShowsList
import ServiceAPI
import ServiceAPIMocks
import XCTest

final class ShowsListInteractorTests: XCTestCase {
    
    private var presenter: ShowsListPresentingMock!
    private var router: ShowsListRoutingMock!
    private var service: ShowsServicingMock!
    private var interactor: ShowsListInteractor!
    
    override func setUp() {
        presenter = ShowsListPresentingMock()
        router = ShowsListRoutingMock()
        service = ShowsServicingMock()
        interactor = ShowsListInteractor(
            router: router,
            showsService: service
        )
        
        interactor.presenter = presenter
        
        service.showsHandler = { _ in
            Just(ShowsResult.didFinish)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    }
    
    func test_viewDidLoad_showsLoading() {
        // given
        presenter.showLoadingCallCount = 0
        
        // when
        interactor.viewDidLoad()
        
        // verify
        XCTAssertEqual(1, presenter.showLoadingCallCount)
    }
    
    func test_viewDidLoad_callsService_shows() {
        // given
        service.showsCallCount = 0
        
        // when
        interactor.viewDidLoad()
        
        // verify
        XCTAssertEqual(1, service.showsCallCount)
    }
    
    func test_viewDidLoad_serviceFailure_hidesLoading() {
        // given
        let exp = expectation(description: "hide loading")
        service_shows_error()
        presenter.hideLoadingHandler = {
            exp.fulfill()
        }
        presenter.hideLoadingCallCount = 0
        
        // when
        interactor.viewDidLoad()
        
        // verify
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(1, service.showsCallCount)
        XCTAssertEqual(1, presenter.hideLoadingCallCount)
    }
    
    func test_viewDidLoad_serviceSuccess_didFinish_hidesLoading() {
        // given
        let exp = expectation(description: "hide loading")
        service_shows_success(result: .didFinish)
        presenter.hideLoadingHandler = {
            exp.fulfill()
        }
        presenter.hideLoadingCallCount = 0
        
        // when
        interactor.viewDidLoad()
        
        // verify
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(1, service.showsCallCount)
        XCTAssertEqual(1, presenter.hideLoadingCallCount)
    }
    
    func test_viewDidLoad_serviceSuccess_shows_hidesLoading() {
        // given
        let exp = expectation(description: "hide loading")
        service_shows_success(result: .shows([]))
        presenter.hideLoadingHandler = {
            exp.fulfill()
        }
        presenter.hideLoadingCallCount = 0
        
        // when
        interactor.viewDidLoad()
        
        // verify
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(1, service.showsCallCount)
        XCTAssertEqual(1, presenter.hideLoadingCallCount)
    }
    
    func test_viewDidLoad_serviceFailure_callsPresenter_updateList_withEmptyList() {
        // given
        let exp = expectation(description: "presenter call with empty list")
        service_shows_error()
        presenter.updateListHandler = { shows in
            XCTAssertTrue(shows.isEmpty)
            exp.fulfill()
        }
        presenter.updateListCallCount = 0
        
        // when
        interactor.viewDidLoad()
        
        // verify
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(1, service.showsCallCount)
        XCTAssertEqual(1, presenter.updateListCallCount)
    }
    
    func test_viewDidLoad_serviceSuccess_didFinish_callsPresenter_updateList_withEmptyList() {
        // given
        let exp = expectation(description: "presenter call with empty list")
        service_shows_success(result: .didFinish)
        presenter.updateListHandler = { shows in
            XCTAssertTrue(shows.isEmpty)
            exp.fulfill()
        }
        presenter.updateListCallCount = 0
        
        // when
        interactor.viewDidLoad()
        
        // verify
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(1, service.showsCallCount)
        XCTAssertEqual(1, presenter.updateListCallCount)
    }
    
    func test_viewDidLoad_serviceSuccess_shows_callsPresenter_updateList_withShows() {
        // given
        let exp = expectation(description: "presenter call with shows")
        let shows = [show(), show(), show()]
        service_shows_success(result: .shows(shows))
        presenter.updateListHandler = { receivedShows in
            XCTAssertEqual(shows, receivedShows)
            exp.fulfill()
        }
        presenter.updateListCallCount = 0
        
        // when
        interactor.viewDidLoad()
        
        // verify
        wait(for: [exp], timeout: 1)
        XCTAssertEqual(1, service.showsCallCount)
        XCTAssertEqual(1, presenter.updateListCallCount)
    }
    
    func test_didSelect_routesToDetails() {
        // given
        let show = show()
        router.showDetailHandler = { receivedShow in
            XCTAssertIdentical(show, receivedShow)
        }
        router.showDetailsCallCount = 0
        
        // when
        interactor.didSelect(show: show)
        
        // verify
        XCTAssertEqual(1, router.showDetailsCallCount)
    }
    
    // MARK: - Pagination tests
    
    func test_didShowItemAt_notLastIndex_doesNotPaginate() {
        // given
        firstDataFetch(count: 3)
        presenter.updateLoadingNewPageCallCount = 0
        service.showsCallCount = 0
        
        // when
        interactor.didShowItemAt(index: 0)
        interactor.didShowItemAt(index: 1)
        
        // verify
        XCTAssertEqual(0, presenter.updateLoadingNewPageCallCount)
        XCTAssertEqual(0, service.showsCallCount)
    }
    
    func test_didShowItemAt_lastIndex_paginate() {
        // given
        let firstPage = firstDataFetch(count: 3)
        let exp = expectation(description: "pagination")
        let newPage = [show(), show(), show()]
        service_shows_success(result: .shows(newPage), expectedPage: 1)
        presenter.updateListHandler = { receivedShows in
            XCTAssertEqual(firstPage + newPage, receivedShows)
            exp.fulfill()
        }
        service.showsCallCount = 0
        presenter.updateLoadingNewPageCallCount = 0
        
        // when
        interactor.didShowItemAt(index: 2)
        
        // verify
        XCTAssertEqual(1, presenter.updateLoadingNewPageCallCount)
        XCTAssertEqual(1, service.showsCallCount)
        wait(for: [exp], timeout: 1)
    }
    
    func test_multiplePaginations_works() {
        let _1 = firstDataFetch()
        let _2 = paginate(expectedPage: 1, currentList: _1)
        let _3 = paginate(expectedPage: 2, currentList: _1 + _2)
        let _4 = paginate(expectedPage: 3, currentList: _1 + _2 + _3)
        let _5 = paginate(expectedPage: 4, currentList: _1 + _2 + _3 + _4)
        paginate(expectedPage: 5, currentList: _1 + _2 + _3 + _4 + _5)
    }
    
    func test_pagination_serviceFailure_stopsPaginating() {
        // given
        let firstPage = firstDataFetch()
        let secondPage = paginate(expectedPage: 1, currentList: firstPage)
        let currentList = firstPage + secondPage
        // setting service error -> will fail next pagination
        service_shows_error(expectedPage: 2)
        service.showsCallCount = 0
        let showNewPageLoadingExp = expectation(description: "show new page loading")
        let hideNewPageLoadingExp = expectation(description: "hide new page loading")
        presenter.updateLoadingNewPageHandler = { receivedValue in
            if receivedValue {
                showNewPageLoadingExp.fulfill()
            } else {
                hideNewPageLoadingExp.fulfill()
            }
        }
        
        // when
        // displaying last item from list -> trigger pagination
        interactor.didShowItemAt(index: currentList.count - 1)
        // did reach service -> error -> finish paginating
        XCTAssertEqual(1, service.showsCallCount)
        wait(for: [showNewPageLoadingExp, hideNewPageLoadingExp], timeout: 1)
        service.showsCallCount = 0
        presenter.updateLoadingNewPageCallCount = 0
        // try paginating again
        interactor.didShowItemAt(index: currentList.count - 1)
        
        // verify
        XCTAssertEqual(0, service.showsCallCount)
        XCTAssertEqual(0, presenter.updateLoadingNewPageCallCount)
    }
    
    func test_pagination_serviceSuccess_didFinishPaging_stopsPaginating() {
        // given
        let firstPage = firstDataFetch()
        let secondPage = paginate(expectedPage: 1, currentList: firstPage)
        let currentList = firstPage + secondPage
        // setting service ending pagination -> will fail next pagination
        service_shows_success(result: .didFinish, expectedPage: 2)
        service.showsCallCount = 0
        let showNewPageLoadingExp = expectation(description: "show new page loading")
        let hideNewPageLoadingExp = expectation(description: "hide new page loading")
        presenter.updateLoadingNewPageHandler = { receivedValue in
            if receivedValue {
                showNewPageLoadingExp.fulfill()
            } else {
                hideNewPageLoadingExp.fulfill()
            }
        }
        
        // when
        // displaying last item from list -> trigger pagination
        interactor.didShowItemAt(index: currentList.count - 1)
        // did reach service -> error -> finish paginating
        XCTAssertEqual(1, service.showsCallCount)
        wait(for: [showNewPageLoadingExp, hideNewPageLoadingExp], timeout: 1)
        service.showsCallCount = 0
        presenter.updateLoadingNewPageCallCount = 0
        // try paginating again
        interactor.didShowItemAt(index: currentList.count - 1)
        
        // verify
        XCTAssertEqual(0, service.showsCallCount)
        XCTAssertEqual(0, presenter.updateLoadingNewPageCallCount)
    }
    
    // MARK: - Helpers
    
    private func show() -> Show {
        Show(
            id: UUID().hashValue,
            name: UUID().uuidString,
            genres: [],
            summary: "Test summary",
            year: 2000,
            image: SimpleImage(
                medium: nil,
                original: nil
            )
        )
    }
    
    private func service_shows_error(
        error: Error = NSError(),
        expectedPage: UInt = .zero,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        service.showsHandler = { receivedPage in
            XCTAssertEqual(expectedPage, receivedPage, file: file, line: line)
            return Fail(
                outputType: ShowsResult.self,
                failure: error
            ).eraseToAnyPublisher()
        }
        service.showsCallCount = 0
    }
    
    private func service_shows_success(
        result: ShowsResult,
        expectedPage: UInt = .zero,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        service.showsHandler = { receivedPage in
            XCTAssertEqual(expectedPage, receivedPage, file: file, line: line)
            return Just(result)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        service.showsCallCount = 0
    }
    
    @discardableResult
    private func firstDataFetch(
        count: Int = 3,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> [Show] {
        // given
        let updateListExp = expectation(description: "presenter update list")
        let hideLoadingExp = expectation(description: "presenter hide loading")
        let shows = (1...count).map { _ in show() }
        service_shows_success(result: .shows(shows), file: file, line: line)
        presenter.updateListHandler = { receivedShows in
            XCTAssertEqual(shows, receivedShows, file: file, line: line)
            updateListExp.fulfill()
        }
        presenter.hideLoadingHandler = {
            hideLoadingExp.fulfill()
        }
        presenter.updateListCallCount = 0
        presenter.showLoadingCallCount = 0
        presenter.hideLoadingCallCount = 0
        
        // when
        interactor.viewDidLoad()
        
        // verify
        XCTAssertEqual(1, presenter.showLoadingCallCount)
        wait(for: [hideLoadingExp, updateListExp], timeout: 1)
        return shows
    }
    
    @discardableResult
    private func paginate(
        count: Int = 3,
        expectedPage: UInt,
        currentList: [Show],
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> [Show] {
        let exp = expectation(description: "pagination")
        let newPage = (1...count).map { _ in show() }
        service_shows_success(
            result: .shows(newPage),
            expectedPage: expectedPage,
            file: file,
            line: line
        )
        presenter.updateListHandler = { receivedShows in
            XCTAssertEqual(currentList + newPage, receivedShows, file: file, line: line)
            exp.fulfill()
        }
        service.showsCallCount = 0
        presenter.updateLoadingNewPageCallCount = 0
        
        // when
        interactor.didShowItemAt(index: currentList.count - 1)
        
        // verify
        XCTAssertEqual(
            1,
            presenter.updateLoadingNewPageCallCount,
            "updateLoadingNewPageCallCount",
            file: file,
            line: line
        )
        XCTAssertEqual(
            1,
            service.showsCallCount,
            "showsCallCount",
            file: file,
            line: line
        )
        wait(for: [exp], timeout: 1)
        return newPage
    }
    
}
