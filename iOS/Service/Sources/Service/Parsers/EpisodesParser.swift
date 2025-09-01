//
//  File.swift
//  Service
//
//  Created by Renan Germano on 30/08/25.
//

import Domain
import Foundation

public protocol EpisodesParsing {
    func parse(data: Data) -> Result<[Episode], Error>
}

final class EpisodesParser: EpisodesParsing {
    
    private let decoder: JSONDecoder
    private let imageParser: SimpleImageParsing
    
    init(
        decoder: JSONDecoder = .init(),
        imageParser: SimpleImageParsing = SimpleImageParser()
    ) {
        self.decoder = decoder
        self.imageParser = imageParser
    }
    
    // MARK: - EpisodesParsing
    
    func parse(data: Data) -> Result<[Episode], any Error> {
        do {
            let dto = try decoder.decode([EpisodeDTO].self, from: data)
            return .success(dto.compactMap(parse))
        } catch {
            // TODO: Log parsing error
            return .failure(error)
        }
    }
    
    // MARK: private
    
    private func parse(dto: EpisodeDTO) -> Episode? {
        guard let id = dto.id else {
            // TODO: Log parsing error
            return nil
        }
        
        guard let name = dto.name?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            // TODO: Log parsing error
            return nil
        }
        
        return Episode(
            id: id,
            season: getSeason(from: dto),
            episode: getEpisode(from: dto),
            name: name,
            summary: getSummary(from: dto),
            image: imageParser.parse(dto: dto.image)
        )
    }
    
    private func getSeason(from dto: EpisodeDTO) -> Int {
        guard let season = dto.season else {
            // TODO: Log error
            return .zero
        }
        return season
    }
    
    private func getEpisode(from dto: EpisodeDTO) -> Int {
        guard let number = dto.number else {
            // TODO: Log error
            return .zero
        }
        return number
    }
    
    private func getSummary(from dto: EpisodeDTO) -> String {
        if let summary = dto.summary?.trimmingCharacters(in: .whitespacesAndNewlines) {
            if summary.isEmpty {
                // TODO: Log error
            }
            return summary
        } else {
            // TODO: Log error
            return ""
        }
    }
    
}
