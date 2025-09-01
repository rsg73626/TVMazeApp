//
//  File.swift
//  Domain
//
//  Created by Renan Germano on 30/08/25.
//

import Foundation

public final class Image {
    let width: Float
    let height: Float
    let url: URL
    let poster: Bool
    let main: Bool
    
    public init(width: Float, height: Float, url: URL, poster: Bool, main: Bool) {
        self.width = width
        self.height = height
        self.url = url
        self.poster = poster
        self.main = main
    }
}
