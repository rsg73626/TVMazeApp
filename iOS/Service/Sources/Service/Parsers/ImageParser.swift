//
//  File.swift
//  Service
//
//  Created by Renan Germano on 30/08/25.
//

import Domain
import Foundation

protocol ImageParsing {
    func parse(data: Data) -> Result<[Image], Error>
}

final class ImageParser: ImageParsing {
    
    let decoder: JSONDecoder
    
    init(decoder: JSONDecoder = .init()) {
        self.decoder = decoder
    }
    
    // MARK: - ImageParsing
    
    func parse(data: Data) -> Result<[Image], Error> {
        do {
            let dto = try decoder.decode([ImageDTO].self, from: data)
            return .success(parse(dto))
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: - Private
    
    private func parse(_ imagesDTO: [ImageDTO]) -> [Image] {
        imagesDTO
            .flatMap { imageDTO in
                (imageDTO.resolutions?.all ?? []).map { resolutionDTO in
                    Self.parse(
                        resolution: resolutionDTO,
                        type: imageDTO.type ?? "",
                        main: imageDTO.main ?? false
                    )
                }
            }
            .compactMap { $0 }
    }
    
    static private func parse(resolution: ResolutionDTO, type: String, main: Bool) -> Image? {
        if resolution.width == nil {
            // TODO: Log parsing error
        }
        if resolution.height == nil {
            // TODO: Log parsing error
        }
        guard let urlStr = resolution.url else {
            // TODO: Log parsing error
            return nil
        }
        guard let url = URL(string: urlStr) else {
            // TODO: Log parsing error
            return nil
        }
        return Image(
            width: resolution.width ?? .zero,
            height: resolution.height ?? .zero,
            url: url,
            poster: type.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() == .posterType,
            main: main
        )
    }
    
}

fileprivate extension String {
    static let posterType = "poster"
}
