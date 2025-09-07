//
//  File.swift
//  ShowsList
//
//  Created by Renan Germano on 06/09/25.
//

import Combine
import Domain
import ServiceAPIMocks
@testable import ShowsList
import XCTest

final class ImageLoaderTests: XCTestCase {
    
    private var dataFetcher: DataFetchingMock!
    private let placeholder = UIImage()
    private var imageLoader: ImageLoader!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        
        dataFetcher = DataFetchingMock()
        imageLoader = ImageLoader(dataFetcher: dataFetcher, defaultPlaceholder: placeholder)
    }
    
    override func tearDown() {
        super.tearDown()
        
        cancellables.forEach { $0.cancel() }
        cancellables = []
    }
    
    func test_image_dataFetcherSuccess_emitsImage() {
        // setup
        let useCases: [SimpleImage] = [
            .init(medium: .medium, original: .original),
            .init(medium: .medium, original: nil),
            .init(medium: nil, original: .original)
        ]
        let dataFetcherExpectations: [URL] = [
            .medium,
            .medium,
            .original
        ]
        
        for (useCase, urlExp) in zip(useCases, dataFetcherExpectations) {
            // given
            let reachedDataFetcher = expectation(description: "reached data fetcher")
            let loadedImage = expectation(description: "loaded image")
            let data = UUID().uuidString.data(using: .utf8)!
            self.imageLoader = ImageLoader(dataFetcher: dataFetcher, defaultPlaceholder: placeholder)
            var dataToImageCallCount = 0
            dataFetcher.fetchDataHandler = { receivedURL in
                XCTAssertEqual(urlExp, receivedURL)
                reachedDataFetcher.fulfill()
                return Just(data)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
            imageLoader.dataToImage = { receivedData in
                dataToImageCallCount += 1
                XCTAssertEqual(data, receivedData)
                return self.placeholder
            }
            dataFetcher.fetchDataCallCount = 0
            
            // when
            assertImagedLoadedFor(
                show: show(image: useCase),
                loadedImageExpectation: loadedImage
            )
            
            // verify
            wait(for: [reachedDataFetcher, loadedImage], timeout: 1)
            XCTAssertEqual(1, dataFetcher.fetchDataCallCount)
            XCTAssertEqual(1, dataToImageCallCount)
        }
    }
    
    func test_image_dataFetcherFailure_emitsPlaceholder() {
        // setup
        let useCases: [SimpleImage] = [
            .init(medium: .medium, original: nil),
            .init(medium: nil, original: .original)
        ]
        let dataFetcherExpectations: [URL] = [
            .medium,
            .original
        ]
        
        for (useCase, urlExp) in zip(useCases, dataFetcherExpectations) {
            // given
            let reachedDataFetcher = expectation(description: "reached data fetcher")
            let loadedImage = expectation(description: "loaded image")
            dataFetcher.fetchDataHandler = { receivedURL in
                XCTAssertEqual(urlExp, receivedURL)
                reachedDataFetcher.fulfill()
                return Fail(outputType: Data.self, failure: NSError())
                    .eraseToAnyPublisher()
            }
            imageLoader.dataToImage = { receivedData in
                XCTFail()
                return self.placeholder
            }
            dataFetcher.fetchDataCallCount = 0
            
            // when
            assertImagedLoadedFor(
                show: show(image: useCase),
                loadedImageExpectation: loadedImage
            )
            
            // verify
            wait(for: [reachedDataFetcher, loadedImage], timeout: 1)
            XCTAssertEqual(1, dataFetcher.fetchDataCallCount)
        }
    }
    
    func test_image_bothURLs_dataFetcherFailure_triesToLoadImageFromBothURLs() {
        // given
        let reachedDataFetcher = expectation(description: "reached data fetcher")
        let loadedImage = expectation(description: "loaded image")
        var dataToImageCallCount = 0
        var capturedURLs = [URL]()
        dataFetcher.fetchDataHandler = { receivedURL in
            capturedURLs.append(receivedURL)
            reachedDataFetcher.fulfill()
            return Fail(outputType: Data.self, failure: NSError())
                .eraseToAnyPublisher()
        }
        imageLoader.dataToImage = { receivedData in
            dataToImageCallCount += 1
            return self.placeholder
        }
        reachedDataFetcher.expectedFulfillmentCount = 2
        dataFetcher.fetchDataCallCount = 0
        
        // when
        assertImagedLoadedFor(
            show: show(image: .both),
            loadedImageExpectation: loadedImage
        )
        
        // verify
        wait(for: [reachedDataFetcher, loadedImage], timeout: 1)
        XCTAssertEqual([.medium, .original], capturedURLs)
        XCTAssertEqual(2, dataFetcher.fetchDataCallCount)
        XCTAssertEqual(0, dataToImageCallCount)
    }
    
    func test_image_emptyImage_doesNotCallDataFetcher_emitsPlaceholder() {
        // given
        dataFetcher.fetchDataCallCount = 0
        
        // when
        assertImagedLoadedFor(show: show(image: .empty))
        
        // verify
        XCTAssertEqual(0, dataFetcher.fetchDataCallCount)
    }
    
    func test_image_cashesValueInMemory() {
        // given
        let reachedDataFetcher = expectation(description: "reached data fetcher")
        let loadedImage = expectation(description: "loaded image")
        var dataToImageCallCount = 0
        let urlExp = URL.medium
        let show = self.show(image: .init(medium: urlExp, original: nil))
        dataFetcher.fetchDataHandler = { receivedURL in
            XCTAssertEqual(urlExp, receivedURL)
            reachedDataFetcher.fulfill()
            return Just(Data())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        imageLoader.dataToImage = { receivedData in
            dataToImageCallCount += 1
            return self.placeholder
        }
        dataFetcher.fetchDataCallCount = 0
        reachedDataFetcher.expectedFulfillmentCount = 1
        loadedImage.expectedFulfillmentCount = 2
        
        // when
        assertImagedLoadedFor(show: show, loadedImageExpectation: loadedImage)
        assertImagedLoadedFor(show: show, loadedImageExpectation: loadedImage)
        
        // verify
        wait(for: [reachedDataFetcher, loadedImage], timeout: 1)
        XCTAssertEqual(1, dataFetcher.fetchDataCallCount)
        XCTAssertEqual(1, dataToImageCallCount)
    }
    
    // MARK: - Helpers
    
    private func show(image: SimpleImage) -> Show {
        Show.init(
            id: UUID().hashValue,
            name: "test-name",
            genres: [],
            summary: "test-summary",
            year: nil,
            image: image
        )
    }
    
    private func assertImagedLoadedFor(
        show: Show,
        loadedImageExpectation: XCTestExpectation,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        imageLoader
            .image(for: show)
            .sink { receivedImage in
                XCTAssertIdentical(
                    self.placeholder,
                    receivedImage,
                    "Wrong image",
                    file: file,
                    line: line
                )
                loadedImageExpectation.fulfill()
            }
            .store(in: &cancellables)
    }
    
    private func assertImagedLoadedFor(
        show: Show,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let exp = expectation(description: "loaded image")
        assertImagedLoadedFor(show: show, loadedImageExpectation: exp, file: file, line: line)
        wait(for: [exp], timeout: 1)
    }
    
}

fileprivate extension SimpleImage {
    
    nonisolated(unsafe) static let empty = SimpleImage(medium: nil, original: nil)
    nonisolated(unsafe) static let both = SimpleImage(medium: .medium, original: .original)
    
}

fileprivate extension URL {
    static let medium = URL(string: "www.test.com/image/medium")!
    static let original = URL(string: "www.test.com/image/original")!
}
