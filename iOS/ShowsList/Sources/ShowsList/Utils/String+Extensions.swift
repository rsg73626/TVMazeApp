//
//  File.swift
//  ShowsList
//
//  Created by Renan Germano on 08/09/25.
//

import Foundation

func localized(_ key: String.LocalizationValue) -> String {
    .init(
        localized: key,
        table: "Localizable",
        bundle: .module
    )
}
