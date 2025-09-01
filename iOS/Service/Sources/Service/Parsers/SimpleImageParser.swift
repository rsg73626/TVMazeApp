//
//  File.swift
//  Service
//
//  Created by Renan Germano on 30/08/25.
//

import Domain
import Foundation

protocol SimpleImageParsing {
    
    func parse(dto: SimpleImageDTO?) -> SimpleImage
    
}

final class SimpleImageParser: SimpleImageParsing {
    
    // MARK: - ImageParsing
    
    func parse(dto: SimpleImageDTO?) -> SimpleImage {
        guard let dto else {
            return .init(medium: nil, original: nil)
        }
        return SimpleImage(
            medium: mediumImageURL(from: dto),
            original: originalImageURL(from: dto)
        )
    }
    
    // MARK: - Private
    
    private func mediumImageURL(from dto: SimpleImageDTO) -> URL? {
        guard let medium = dto.medium else {
            // TODO: Log error
            return nil
        }
        guard let url = URL(string: medium) else {
            // TODO: Log error
            return nil
        }
        return url
    }
    
    private func originalImageURL(from dto: SimpleImageDTO) -> URL? {
        guard let original = dto.original else {
            // TODO: Log error
            return nil
        }
        guard let url = URL(string: original) else {
            // TODO: Log error
            return nil
        }
        return url
    }
    
}
