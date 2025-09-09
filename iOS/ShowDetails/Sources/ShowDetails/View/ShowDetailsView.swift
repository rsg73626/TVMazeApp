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
    
    var listener: ShowDetailsPresentingListener?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                switch viewModel.image {
                case let .image(img):
                    Image(uiImage: img)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                        .padding(padding)
                case .loading:
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
                
                Text(viewModel.title)
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
                
                Text(
                    viewModel
                        .summary
                        .overridingColor(.primary)
                )
                    .font(.body)
                    .padding(.horizontal, padding)
                    .padding(.bottom, padding)
                    
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if !didLoad {
                listener?.viewDidLoad()
                didLoad = true
            }
        }
    }
    
    // MARK: - Private
    
    @ObservedObject private var viewModel = ShowDetailsViewModel()
    @State private var didLoad: Bool = false
    
    private let padding: CGFloat = 16
    
}

extension ShowDetailsView: @preconcurrency ShowDetailsViewing {
    
    func update(imageState: ImageState) {
        viewModel.image = imageState
    }
    
    func update(title: String) {
        viewModel.title = title
    }
    
    func update(year: String?) {
        viewModel.year = year
    }
    
    func update(genres: String) {
        viewModel.genres = genres
    }
    
    func update(summary: AttributedString) {
        viewModel.summary = summary
    }

}

extension AttributedString {
    
    func overridingColor(_ color: Color) -> AttributedString {
        var copy = self
        for run in copy.runs {
            copy[run.range].foregroundColor = color
        }
        return copy
    }
    
}
