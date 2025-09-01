//
//  File.swift
//  Service
//
//  Created by Renan Germano on 30/08/25.
//

import Foundation

final class ResolutionDTO: Decodable {
    let url: String?
    let width: Float?
    let height: Float?
    
    init(url: String?, width: Float?, height: Float?) {
        self.url = url
        self.width = width
        self.height = height
    }
}

final class ResolutionsDTO: Decodable {
    let original: ResolutionDTO?
    let medium: ResolutionDTO?
    
    init(original: ResolutionDTO?, medium: ResolutionDTO?) {
        self.original = original
        self.medium = medium
    }
    
    var all: [ResolutionDTO] {
        [original, medium].compactMap { $0 }
    }
}

final class ImageDTO: Decodable {
    let type: String?
    let main: Bool?
    let resolutions: ResolutionsDTO?
    
    init(type: String?, main: Bool?, resolutions: ResolutionsDTO?) {
        self.type = type
        self.main = main
        self.resolutions = resolutions
    }
}
