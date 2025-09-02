//
//  File.swift
//  ShowsList
//
//  Created by Renan Germano on 01/09/25.
//

import Combine
import Domain
import SwiftUI

struct ShowView: View {
    @ObservedObject var vm: ShowViewModel

    var body: some View {
        HStack(spacing: 12) {
            Group {
                if let img = vm.image {
                    Image(uiImage: img).resizable().scaledToFill()
                } else {
                    Rectangle().opacity(0.1) // placeholder
                }
            }
            .frame(width: 48, height: 48)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            Text(vm.name)
                .lineLimit(1)
        }
    }
}

fileprivate extension UIImage {
    static let placeholder = UIImage() // TODO: replace it with placeholder
}
