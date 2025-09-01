//
//  File.swift
//  Service
//
//  Created by Renan Germano on 29/08/25.
//

import Foundation

final class EpisodeDTO: Decodable {
    
    let id: Int?
    let name: String?
    let season: Int?
    let number: Int?
    let summary: String?
    let image: SimpleImageDTO?
    
    init(id: Int?, name: String?, season: Int?, number: Int?, summary: String?, image: SimpleImageDTO?) {
        self.id = id
        self.name = name
        self.season = season
        self.number = number
        self.summary = summary
        self.image = image
    }
    
}
