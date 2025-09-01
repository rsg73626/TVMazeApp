//
//  File.swift
//  Domain
//
//  Created by Renan Germano on 29/08/25.
//

import Foundation

public final class Episode: Equatable {
    
    public let id: Int
    public let season: Int
    public let episode: Int
    public let name: String
    public let summary: String
    public let image: SimpleImage
    
    public init(id: Int, season: Int, episode: Int, name: String, summary: String, image: SimpleImage) {
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
