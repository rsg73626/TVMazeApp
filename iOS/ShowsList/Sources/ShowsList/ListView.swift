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

public struct ListView: View {
    
    let service: ShowsServicing
    
    @State private var items: [Show] = []
    @State private var cancellable: AnyCancellable?
    @State private var page = UInt.zero
    
    public init(service: ShowsServicing) { self.service = service }
    
    public var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Next") { load(page: page + 1) }
                Spacer()
            }
            List {
                ForEach(items, id: \.id) { Text($0.name) }
            }
            .navigationTitle("Itens")
        }
        .onAppear { load(page: page) }
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
                        items = items + shows
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
