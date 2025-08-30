//
//  File.swift
//  Service
//
//  Created by Renan Germano on 29/08/25.
//

import Combine
import Domain
import Foundation
import ServiceAPI

public final class ShowsService: ShowsServicing {
    
    let session: URLSession
    let showsParser: ShowsParsing
    let episodesParser: EpisodesParsing
    
    public init(
        session: URLSession = .shared,
        showsParser: ShowsParsing? = nil,
        episodesParser: EpisodesParsing? = nil
    ) {
        self.session = session
        self.showsParser = showsParser ?? ShowsParser()
        self.episodesParser = episodesParser ?? EpisodesParser()
    }
    
    // MARK: ShowsServicing
    
    public func shows(page: UInt) -> AnyPublisher<ShowsResult, Error> {
        session
            .dataTaskPublisher(for: urlForShows(page: page))
            .tryMap { [showsParser] data, response -> ShowsResult in
                guard (response as? HTTPURLResponse)?.statusCode != .notFound else {
                    return .didFinish
                }
                switch showsParser.parse(data: data) {
                case let .success(shows):
                    return .shows(shows)
                case let .failure(error):
                    throw error
                }
            }
            .eraseToAnyPublisher()
    }
    
    public func episodes(showId: Int) -> AnyPublisher<[Episode], any Error> {
        session
            .dataTaskPublisher(for: urlForEpisodes(showId: showId))
            .tryMap { [episodesParser] data, _ -> [Episode] in
                switch episodesParser.parse(data: data) {
                case let .success(episodes):
                    return episodes
                case let .failure(error):
                    throw error
                }
            }
            .eraseToAnyPublisher()
    }
    
    // MARK: - Private
    
    private let baseUrlStr = "https://api.tvmaze.com"
    
    private func urlForShows(page: UInt) -> URL {
        URL(string: baseUrlStr + "/shows?page=\(page)")!
    }
    
    private func urlForEpisodes(showId: Int) -> URL {
        URL(string: baseUrlStr + "/shows/\(showId)/episodes")!
    }
    
}

extension Int {
    static let notFound = 404
}
