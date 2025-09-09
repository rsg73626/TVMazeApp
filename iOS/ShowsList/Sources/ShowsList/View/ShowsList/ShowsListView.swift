//
//  SwiftUIView.swift
//  ShowsList
//
//  Created by Renan Germano on 30/08/25.
//

import Domain
import Combine
import ServiceAPI
import SwiftUI
import ShowsListAPI

protocol ShowViewProviding {
    func view(for show: Show, isGridLayout: Bool) -> ShowView
}

struct ShowsListView: View, @preconcurrency ShowsListViewing {
    
    init(showViewProvider: ShowViewProviding) {
        viewModel = ShowsListViewModel()
        self.showViewProvider = showViewProvider
    }
    
    var body: some View {
        Group {
            if viewModel.loading {
                loadingView
            } else if viewModel.shows.isEmpty {
                retryView
            } else {
                if layout == .grid {
                    gridView
                } else {
                    listView
                }
            }
        }
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(viewModel.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                // Picker segmentado com duas opções
                Picker(localized("layout"), selection: $layout) {
                    ForEach(LayoutMode.allCases) { m in
                        Label(m.rawValue, systemImage: m.icon).tag(m)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 160)
                .accessibilityLabel(localized("updateLayout"))
            }
        }
    }
    
    // MARK: - ShowsListViewing
    
    var listener: ShowsListViewingListening?
    
    func update(loading: Bool) {
        viewModel.loading = loading
    }
    
    func update(shows: [Show]) {
        viewModel.shows = shows
    }
    
    func update(title: String) {
        viewModel.title = title
    }
    
    func update(loadingNewPage: Bool) {
        viewModel.isPaginating = loadingNewPage
    }
    
    // MARK: - Private
    
    @ObservedObject private var viewModel: ShowsListViewModel
    @State private var didLoad: Bool = false
    @State private var layout: LayoutMode = .list
    
    private let showViewProvider: ShowViewProviding
    private let gridColumns = [GridItem(.adaptive(minimum: 150), spacing: 12)]
    
    private var loadingView: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text(
                    localized("list.loading")
                )
                Spacer()
            }
            Spacer()
        }
    }
    
    private var retryView: some View {
        VStack {
            Spacer()
            Text(localized("ops"))
                .bold()
            Spacer()
            Text(localized("genericError"))
            Text(localized("tryAgain"))
            Spacer()
            Button(
                action: {
                    listener?.didPressRetryButton()
                }
            ) {
                Text(localized("retry"))
            }
            Spacer()
        }
        .onAppear {
            if !didLoad {
                listener?.viewDidLoad()
                didLoad = true
            }
        }
    }
    
    private var listView: some View {
        return List {
            ForEach(Array(viewModel.shows.enumerated()), id: \.offset) { index, show in
                showViewProvider.view(for: show, isGridLayout: false)
                    .onTapGesture {
                        listener?.didSelect(show: show)
                    }
                    .onAppear {
                        listener?.didShowItemAt(index: index)
                    }
            }
            if viewModel.isPaginating {
                VStack {
                    HStack {
                        Spacer()
                        Text(
                            localized("list.paginating")
                        )
                        Spacer()
                    }
                }
                .frame(height: 44)
            }
        }
        .scrollIndicators(.hidden)
    }
    
    private var gridView: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: 12) {
                ForEach(Array(viewModel.shows.enumerated()), id: \.offset) { index, show in
                    showViewProvider.view(for: show, isGridLayout: true)
                        .onTapGesture {
                            listener?.didSelect(show: show)
                        }
                        .onAppear {
                            listener?.didShowItemAt(index: index)
                        }
                }
                if viewModel.isPaginating {
                    VStack {
                        HStack {
                            Spacer()
                            Text(
                                localized("list.paginating")
                            )
                            Spacer()
                        }
                    }
                    .frame(height: 44)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .scrollIndicators(.hidden)
        }
    }
    
}

// MARK: - Helpers

fileprivate final class ShowsListViewModel: ObservableObject {
    @Published var title: String
    @Published var shows: [Show]
    @Published var loading: Bool
    @Published var isPaginating: Bool
    
    init(
        title: String = "",
        shows: [Show] = [],
        loading: Bool = false,
        isPaginating: Bool = false
    ) {
        self.title = title
        self.shows = shows
        self.loading = loading
        self.isPaginating = isPaginating
    }
}

fileprivate enum LayoutMode: String, CaseIterable, Identifiable {
    case list = "Lista"
    case grid = "Grid"
    var id: String { rawValue }
    var icon: String {
        switch self {
        case .list: return "list.bullet"
        case .grid: return "square.grid.2x2"
        }
    }
}
