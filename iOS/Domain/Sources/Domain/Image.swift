//
//  File.swift
//  Domain
//
//  Created by Renan Germano on 29/08/25.
//

import Foundation

public final class Image {
    let medium: URL?
    let original: URL?
    
    init(medium: URL?, original: URL?) {
        self.medium = medium
        self.original = original
    }
}
