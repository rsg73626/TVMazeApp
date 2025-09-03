//
//  File.swift
//  Local
//
//  Created by Renan Germano on 03/09/25.
//

import Domain
import Foundation

public protocol ShowsParsing {
    func parse(entities: [ShowEntity]) -> [Show]
}

final class ShowsParser: ShowsParsing {
    
    let decoder: JSONDecoder
    
    init(decoder: JSONDecoder = .init()) {
        self.decoder = decoder
    }
    
    // MARK: - ShowParsing
    
    func parse(entities: [ShowEntity]) -> [Show] {
        entities.compactMap(parse)
    }
    
    // MARK: - Private
    
    private func parse(_ entity: ShowEntity) -> Show? {
        guard let name = entity.name else {
            // TODO: Log parsing error
            return nil
        }
        
        return Show(
            id: Int(entity.id),
            name: name,
            genres: genres(from: entity),
            summary: summary(from: entity),
            year: Int(entity.year),
            image: image(from: entity)
        )
    }
    
    private func genres(from entity: ShowEntity) -> [String] {
        guard let data = entity.genresData else {
            // TODO: Log parsing error
            return []
        }
        guard let genres = try? decoder.decode([String].self, from: data) else {
            // TODO: Log parsing error
            return []
        }
        return genres
    }
    
    private func summary(from entity: ShowEntity) -> String {
        guard let summary = entity.summary?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            // TODO: Log parsing error
            return ""
        }
        return summary
    }
    
    private func image(from entity: ShowEntity) -> SimpleImage {
        guard let image = entity.image else {
            // TODO: Log parsing error
            return .init(medium: nil, original: nil)
        }
        return SimpleImage(
            medium: image.medium,
            original: image.original
        )
    }
    
}
