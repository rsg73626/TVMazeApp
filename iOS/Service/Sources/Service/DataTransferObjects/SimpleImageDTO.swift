//
//  File.swift
//  Service
//
//  Created by Renan Germano on 29/08/25.
//

import Foundation

final class SimpleImageDTO: Decodable {
    let medium: String?
    let original: String?
    
    init(medium: String?, original: String?) {
        self.medium = medium
        self.original = original
    }
}
