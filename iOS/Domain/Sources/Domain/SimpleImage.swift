//
//  File.swift
//  Domain
//
//  Created by Renan Germano on 29/08/25.
//

import Foundation

public final class SimpleImage {
    public let medium: URL?
    public let original: URL?
    
    public init(medium: URL?, original: URL?) {
        self.medium = medium
        self.original = original
    }
}
