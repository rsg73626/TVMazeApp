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
    @ObservedObject var viewModel: ShowViewModel
    
    private let grid: Bool
    
    init(
        viewModel: ShowViewModel,
        grid: Bool = false
    ) {
        self.viewModel = viewModel
        self.grid = grid
    }

    var body: some View {
        if grid {
            gridView
        } else {
            listView
        }
    }
    
    private var listView: some View {
        HStack(spacing: 12) {
            Group {
                if let img = viewModel.image {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 220)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    Rectangle()
                        .opacity(0.1)
                        .scaledToFill()
                        .frame(height: 220)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .frame(width: 160, height: 220)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            Text(viewModel.name)
                .lineLimit(1)
        }
    }
    
    private var gridView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Group {
                if let img = viewModel.image {
                    Image(uiImage: img)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 220)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    Rectangle()
                        .opacity(0.1)
                        .scaledToFill()
                        .frame(height: 220)
                        .frame(maxWidth: .infinity)
                        .clipped()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .frame(width: 160, height: 220)
            .clipShape(RoundedRectangle(cornerRadius: 8))

            Text(viewModel.name)
                .font(.subheadline)
                .lineLimit(2)
        }
    }
}
