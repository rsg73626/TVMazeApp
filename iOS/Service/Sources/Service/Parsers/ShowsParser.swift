//
//  File.swift
//  Service
//
//  Created by Renan Germano on 29/08/25.
//

import Domain
import Foundation

enum ShowsParseResult {
    
}

public protocol ShowsParsing {
    func parse(data: Data) -> Result<[Show], Error>
}

final class ShowsParser: ShowsParsing {
    
    let decoder: JSONDecoder
    let imageParser: ImageParsing
    
    init(
        decoder: JSONDecoder = .init(),
        imageParser: ImageParsing = ImageParser()
    ) {
        self.decoder = decoder
        self.imageParser = imageParser
    }
    
    // MARK: - ShowsParsing
    
    func parse(data: Data) -> Result<[Show], Error> {
        do {
            let dto = try decoder.decode([ShowDTO].self, from: data)
            return .success(dto.compactMap(parse))
        } catch {
            // TODO: Log parsing error
            return .failure(error)
        }
    }
    
    // MARK: - Private
    
    private func parse(dto: ShowDTO) -> Show? {
        guard let id = dto.id else {
            // TODO: Log parsing error
            return nil
        }
        
        guard let name = dto.name?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            // TODO: Log parsing error
            return nil
        }
        
        return Show(
            id: id,
            name: name,
            genres: getGenres(from: dto),
            summary: getSummary(from: dto),
            year: getYear(from: dto),
            image: imageParser.parse(dto: dto.image)
        )
    }
    
    private func getGenres(from dto: ShowDTO) -> [String] {
        if let genres = dto.genres {
            if genres.isEmpty {
                // TODO: Log error
            }
            return genres
        } else {
            // TODO: Log error
            return []
        }
    }
    
    private func getSummary(from dto: ShowDTO) -> String {
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
    
    private func getYear(from dto: ShowDTO) -> Int? {
        guard let premiered = dto.premiered?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            // TODO: Log error
            return nil
        }
        guard let yearStr = premiered.components(separatedBy: "-").first,
              yearStr.count == 4,
              let year = Int(yearStr) else {
            // TODO: Log error
            return nil
        }
        return year
    }
    
}
