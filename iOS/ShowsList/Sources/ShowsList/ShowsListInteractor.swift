//
//  File.swift
//  ShowsList
//
//  Created by Renan Germano on 01/09/25.
//

import Combine
import Domain
import Foundation
import ServiceAPI
import ShowsListAPI

protocol ShowsListPresenting {
    func updateTitle()
    func update(loading: Bool)
    func update(shows: [Show])
    func update(loadingNewPage: Bool)
}

final class ShowsListInteractor: ShowsListViewingListening {
    
    let presenter: ShowsListPresenting
    let router: ShowsListRouting
    let showsService: ShowsServicing
    
    init(
        presenter: ShowsListPresenting,
        router: ShowsListRouting,
        showsService: ShowsServicing
    ) {
        self.presenter = presenter
        self.router = router
        self.showsService = showsService
    }
    
    // MARK: - ShowsListViewingListening
    
    func viewDidLoad() {
        presenter.updateTitle()
        fetchData()
    }
    
    func didSelect(show: Show) {
        router.showDetails(for: show)
    }
    
    func didShowItemAt(index: Int) {
        if index == shows.count - 1 {
            getNextPage()
        }
    }
    
    func didPressRetryButton() {
        fetchData()
    }
    
    // MARK: - Private
    
    private var shows = [Show]()
    private var cancelables = Set<AnyCancellable>()
    private var didFinishPaging = false
    private var currentPage: UInt = .zero
    private var isPaginating = false
    
    private func fetchData() {
        cancelCurrentSubscriptions()
        presenter.update(loading: true)
        showsService
            .shows(page: .zero)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] failure in
                    guard let self else { return }
                    switch failure {
                    case .finished:
                        break
                    case .failure(let error):
                        self.presenter.update(loading: false)
                        self.track(apiError: error)
                        self.handlePagingError()
                    }
                },
                receiveValue: { [weak self] result in
                    guard let self else { return }
                    self.presenter.update(loading: false)
                    if case let .shows(shows) = result {
                        self.shows = shows
                        self.presenter.update(shows: self.shows)
                    } else {
                        self.handlePagingError()
                    }
                }
            )
            .store(in: &cancelables)
    }
    
    private func getNextPage() {
        guard !didFinishPaging,
              !isPaginating else {
            return
        }
        isPaginating = true
        presenter.update(loadingNewPage: true)
        cancelCurrentSubscriptions()
        let nextPage = currentPage + 1
        showsService
            .shows(page: nextPage)
            .receive(on: DispatchQueue.main)
            .first()
            .sink(
                receiveCompletion: { [weak self] failure in
                    guard let self else { return }
                    switch failure {
                    case .finished:
                        break
                    case .failure(let error):
                        self.track(apiError: error)
                        self.handlePagingError(allowPagingEnd: true)
                        // TODO: Update this logic. The way it is, the paging will also finish in case the API call fails but there was already some data being presented. This decision was taken because the retry politics would be already applied here; this is, if an error is received here, it means the same request was already tried at least three times, so it's not a matter of retrying the same request again. The ideal solution would be to wait some time and than retry; or, also, skip the current page being fetched and going to the next. This is a decision that should be taken awareness of all team and PO
                        self.isPaginating = false
                        self.presenter.update(loadingNewPage: false)
                    }
                },
                receiveValue: { [weak self] result in
                    guard let self else { return }
                    switch result {
                    case let .shows(shows):
                        self.shows = (self.shows + shows)
                        self.presenter.update(shows: self.shows)
                        self.currentPage = nextPage
                    case .didFinish:
                        self.didFinishPaging = true
                    }
                    self.isPaginating = false
                    self.presenter.update(loadingNewPage: false)
                }
            )
            .store(in: &cancelables)
    }
    
    private func track(apiError: Error) {
        // TODO: register event to monitor API error
    }
    
    private func handlePagingError(allowPagingEnd: Bool = false) {
        if shows.isEmpty {
            presenter.update(shows: [])
        } else {
            didFinishPaging = allowPagingEnd
        }
    }
    
    private func cancelCurrentSubscriptions() {
        cancelables.forEach { $0.cancel() }
    }
    
}
