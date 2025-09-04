//
//  File.swift
//  Domain
//
//  Created by Renan Germano on 30/08/25.
//

import Foundation

public final class Image {
    public let width: Float
    public let height: Float
    public let url: URL
    public let poster: Bool
    public let main: Bool
    
    public init(width: Float, height: Float, url: URL, poster: Bool, main: Bool) {
        self.width = width
        self.height = height
        self.url = url
        self.poster = poster
        self.main = main
    }
}
