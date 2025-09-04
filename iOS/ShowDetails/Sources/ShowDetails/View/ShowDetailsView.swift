//
//  SwiftUIView.swift
//  ShowDetails
//
//  Created by Renan Germano on 04/09/25.
//

import Combine
import Domain

import SwiftUI

struct ShowDetailsView: View {
    
    @ObservedObject private var viewModel: ShowDetailsViewModel
    
    private let padding: CGFloat = 16
    
    init(viewModel: ShowDetailsViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                if let img = viewModel.image {
                    Image(uiImage: img)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .padding(padding)
                } else {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            ProgressView()
                                .progressViewStyle(.circular)
                                .tint(.gray)
                                .scaleEffect(1.2)
                                .padding()
                            Spacer()
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, minHeight: 500)
                }
                
                Text(viewModel.name)
                    .font(.title).bold()
                    .padding(.horizontal, padding)
                
                if let year = viewModel.year {
                    Text(year)
                        .font(.headline)
                        .padding(.horizontal, padding)
                }
                
                Text(viewModel.genres)
                    .font(.headline)
                    .padding(.horizontal, padding)
                    .lineLimit(2)
                
                Text(viewModel.summary)
                    .font(.body)
                    .padding(.horizontal, padding)
                    .padding(.bottom, padding)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
}

class Test: ShowDetailsImageLoading {
    func image(for show: Show) -> AnyPublisher<UIImage, Never> {
        Just(UIImage()).eraseToAnyPublisher()
    }
}

#Preview {
    ShowDetailsView(
        viewModel: ShowDetailsViewModel(
            show: Show(
                id: 1,
                name: "Test",
                genres: [""],
                summary: "Test",
                year: 2000,
                image: .init(
                    medium: nil,
                    original: nil
                )
            ),
            imageLoader: Test()
        )
    )
}
