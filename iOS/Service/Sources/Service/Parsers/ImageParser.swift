//
//  File.swift
//  Service
//
//  Created by Renan Germano on 30/08/25.
//

import Domain
import Foundation

protocol ImageParsing {
    
    func parse(dto: ImageDTO?) -> Image
    
}

final class ImageParser: ImageParsing {
    
    // MARK: - ImageParsing
    
    func parse(dto: ImageDTO?) -> Image {
        guard let dto else {
            return .init(medium: nil, original: nil)
        }
        return Image(
            medium: mediumImageURL(from: dto),
            original: originalImageURL(from: dto)
        )
    }
    
    // MARK: - Private
    
    private func mediumImageURL(from dto: ImageDTO) -> URL? {
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
    
    private func originalImageURL(from dto: ImageDTO) -> URL? {
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
