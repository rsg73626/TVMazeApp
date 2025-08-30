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

struct ListView: View {
    
    let service: ShowsServicing
    
    @State private var items: [Show] = []
    @State private var cancellable: AnyCancellable?
    @State private var page = UInt.zero
    
    public init(service: ShowsServicing) { self.service = service }
    
    public var body: some View {
        List {
            ForEach(items, id: \.id) { Text($0.name) }
        }
        .navigationTitle("Itens")
//        .toolbar {
//            ToolbarItem(placement: .topBarTrailing) {
//                Button("Next") { load(page: page + 1) }
//            }
//            ToolbarItem(placement: .topBarLeading) {
//                Button("Reload") { load(page: page) }
//            }
//        }
        .onAppear { load(page: 1) }
        .onDisappear { cancellable?.cancel() }
    }
    
    private func load(page: UInt = .zero) {
        cancellable = service.shows(page: page)
            .receive(on: DispatchQueue.main) // garante mutações de @State no main
            .sink(
                receiveCompletion: { completion in
                    print("error")
                },
                receiveValue: { result in
                    switch result {
                    case let .shows(shows):
                        items = shows
                    case .didFinish:
                        print("did finish")
                    }
                }
            )
    }
}

//#Preview {
//    ListView(service: ShowsService())
//}
