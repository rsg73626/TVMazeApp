//
//  File.swift
//  Service
//
//  Created by Renan Germano on 29/08/25.
//

import Foundation

final class ShowDTO: Decodable {
    let id: Int?
    let name: String?
    let summary: String?
    let genres: [String]?
    let premiered: String?
    let image: ImageDTO?
    
    init(id: Int, name: String?, summary: String?, genres: [String]?, premiered: String?, image: ImageDTO?) {
        self.id = id
        self.name = name
        self.summary = summary
        self.genres = genres
        self.premiered = premiered
        self.image = image
    }
}
