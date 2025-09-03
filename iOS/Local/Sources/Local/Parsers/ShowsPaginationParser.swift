//
//  File.swift
//  Local
//
//  Created by Renan Germano on 03/09/25.
//

import Domain
import Foundation

public typealias ShowsPagination = (id: String, showsIds: [Int], timestamp: Double)

public protocol ShowsPaginationParsing {
    func parse(entity: ShowsPaginationEntity) -> ShowsPagination?
}

final class ShowsPaginationParser: ShowsPaginationParsing {
    
    let decoder: JSONDecoder
    
    init(
        decoder: JSONDecoder = .init()
    ) {
        self.decoder = decoder
    }
    
    // MARK: - ShowsPaginationParsing
    
    func parse(entity: ShowsPaginationEntity) -> ShowsPagination? {
        guard let id = entity.id else {
            // TODO: Log parsing error
            return nil
        }
        guard let showIdsData = entity.showIds else {
            // TODO: Log parsing error
            return nil
        }
        guard let showsIds = try? decoder.decode([Int].self, from: showIdsData) else {
            // TODO: Log parsing error
            return nil
        }
        return (
            id,
            showsIds,
            entity.timestamp
        )
    }
}
