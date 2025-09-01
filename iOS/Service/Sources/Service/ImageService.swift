//
//  File.swift
//  Service
//
//  Created by Renan Germano on 30/08/25.
//

import Combine
import Domain
import Foundation
import ServiceAPI

public final class ImageService: ImageServicing {
    
    let session: URLSession
    let imageParser: ImageParsing
    
    init(
        session: URLSession = .shared,
        imageParser: ImageParsing = ImageParser()
    ) {
        self.session = session
        self.imageParser = imageParser
    }
    
    public func images(showId: Int) -> AnyPublisher<[Image], Error> {
        session
            .dataTaskPublisher(for: urlForImages(showId: showId))
            .tryMap { [imageParser] data, _ in
                switch imageParser.parse(data: data) {
                case let .success(images):
                    return images
                case let .failure(error):
                    throw error
                }
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private
    
    private let baseUrlStr = "https://api.tvmaze.com"
    
    private func urlForImages(showId: Int) -> URL {
        URL(string: baseUrlStr + "/shows/\(showId)/images")!
    }
    
    
}
