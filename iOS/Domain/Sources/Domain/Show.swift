// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public final class Show: Equatable {
    
    public let id: Int
    public let name: String
    public let genres: [String]
    public let summary: String
    public let year: Int?
    public let image: SimpleImage
    
    public init(id: Int, name: String, genres: [String], summary: String, year: Int?, image: SimpleImage) {
        self.id = id
        self.name = name
        self.genres = genres
        self.summary = summary
        self.year = year
        self.image = image
    }
    
    // MARK: - Equatable
    
    public static func == (lhs: Show, rhs: Show) -> Bool {
        lhs.id == rhs.id
    }
    
}
