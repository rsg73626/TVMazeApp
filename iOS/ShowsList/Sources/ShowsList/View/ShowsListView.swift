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

struct ShowsListView: View {
    
    var listener: ShowsListPresentingListener?
    
    @ObservedObject private var viewModel: ShowsListViewModel
    @State private var didLoad: Bool = false
    
    private let showViewModelFactory: ShowViewModelFactoring
    
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
        if viewModel.loading {
            loadingView
        } else if viewModel.shows.isEmpty {
            retryView
        } else {
            listView
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
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(viewModel.title)
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
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(viewModel.title)
    }
    
    private var listView: some View {
        List {
            ForEach(Array(viewModel.shows.enumerated()), id: \.offset) { index, show in
                ShowView(vm: showViewModelFactory.build(show: show))
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
        .navigationBarTitleDisplayMode(.large)
        .navigationTitle(viewModel.title)
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


