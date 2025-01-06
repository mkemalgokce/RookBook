// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import Foundation

final class BookCompositeLoader<Store: CacheStorable> where Store.Item == LocalBook, Store.Identifier == UUID {
    private let client: HTTPClient
    private let bookStore: Store
    private let scheduler: AnyDispatchQueueScheduler

    private lazy var localRepository = LocalRepository(store: bookStore)

    init(client: HTTPClient, bookStore: Store, scheduler: AnyDispatchQueueScheduler) {
        self.client = client
        self.bookStore = bookStore
        self.scheduler = scheduler
    }

    func makeRemoteWithLocalFallbackLoader(id: UUID) -> AnyPublisher<Book, Error> {
        let remoteLoader = makeRemoteLoader(id: id)
        let localLoader = makeLocalLoader(id: id)

        return remoteLoader
            .caching(to: bookStore, map: LocalBookMapper.map)
            .fallback(to: localLoader)
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }

    private func makeRemoteLoader(id: UUID) -> AnyPublisher<Book, Error> {
        let request = URLRequest(url: URL(string: "https://api.example.com/books/\(id.uuidString)")!)
        let mapper = DecodableResourceResponseMapper<BookDTO>()
        return client
            .perform(request)
            .tryMap(mapper.map)
            .map(BookDTOMapper.map)
            .eraseToAnyPublisher()
    }

    private func makeLocalLoader(id: UUID) -> AnyPublisher<Book, Error> {
        localRepository.fetch(with: id)
            .map(LocalBookMapper.map)
            .eraseToAnyPublisher()
    }
}
