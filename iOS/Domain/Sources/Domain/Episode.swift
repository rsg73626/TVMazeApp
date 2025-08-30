//
//  File.swift
//  Domain
//
//  Created by Renan Germano on 29/08/25.
//

import Foundation

public final class Episode: Equatable {
    
    let id: Int
    let season: Int
    let episode: Int
    let name: String
    let summary: String
    let image: Image
    
    init(id: Int, season: Int, episode: Int, name: String, summary: String, image: Image) {
        self.id = id
        self.season = season
        self.episode = episode
        self.name = name
        self.summary = summary
        self.image = image
    }
    
    // MARK: - Equatable
    
    public static func == (lhs: Episode, rhs: Episode) -> Bool {
        lhs.id == rhs.id
    }
    
}
