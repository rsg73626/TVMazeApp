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

fileprivate final class ShowsListViewModel: ObservableObject {
    @Published var title: String
    @Published var shows: [Show]
    @Published var loading: Bool
    @Published var isPaginating: Bool
    
    init(
        title: String,
        shows: [Show],
        loading: Bool,
        isPaginating: Bool
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

struct ShowsListView: View {
    
    var listener: ShowsListPresentingListener?
    
    private let showViewModelFactory: ShowViewModelFactoring
    private let gridColumns = [GridItem(.adaptive(minimum: 150), spacing: 12)]
    
    @ObservedObject private var viewModel: ShowsListViewModel
    @State private var didLoad: Bool = false
    @State private var layout: LayoutMode = .list
    
    init(
        title: String,
        shows: [Show] = [],
        loading: Bool = false,
        isPaginating: Bool = false,
        showViewModelFactory: ShowViewModelFactoring
    ) {
        viewModel = ShowsListViewModel(
            title: title,
            shows: shows,
            loading: loading,
            isPaginating: isPaginating
        )
        self.showViewModelFactory = showViewModelFactory
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
                Picker("Layout", selection: $layout) {
                    ForEach(LayoutMode.allCases) { m in
                        Label(m.rawValue, systemImage: m.icon).tag(m)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 160) // ajuda a caber na direita
                .accessibilityLabel("Alternar layout")
            }
        }
    }
    
    private var loadingView: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                Text("Loading...")
                Spacer()
            }
            Spacer()
        }
    }
    
    private var retryView: some View {
        VStack {
            Spacer()
            Text("Ops..")
            Text("Something went wrong...")
            Spacer()
            Button(action: { listener?.didPressRetryButton() }) {
                Text("Retry")
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
        List {
            ForEach(Array(viewModel.shows.enumerated()), id: \.offset) { index, show in
                ShowView(viewModel: showViewModelFactory.build(show: show))
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
                        Text("Loading...")
                        Spacer()
                    }
                }
                .frame(height: 44)
            }
        }
    }
    
    private var gridView: some View {
        ScrollView {
            LazyVGrid(columns: gridColumns, spacing: 12) {
                ForEach(Array(viewModel.shows.enumerated()), id: \.offset) { index, show in
                    ShowView(viewModel: showViewModelFactory.build(show: show), grid: true)
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
                            Text("Loading...")
                            Spacer()
                        }
                    }
                    .frame(height: 44)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
    }
}

extension ShowsListView: @preconcurrency ShowsListPresenting {
    
    func showLoading() {
        viewModel.loading = true
    }
    
    func hideLoading() {
        viewModel.loading = false
    }
    
    func update(list: [Show]) {
        viewModel.shows = list
    }
    
    func update(title: String) {
        viewModel.title = title
    }
    
    func update(loadingNewPage value: Bool) {
        viewModel.isPaginating = value
    }
    
}

