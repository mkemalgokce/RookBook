// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import Foundation

extension BookCompositeFactory {
    // MARK: - Public Methods
    func makeRemoteWithLocalFallbackLoader(id: UUID) -> AnyPublisher<Book, Error> {
        let remoteLoader = makeRemoteLoader(id: id)
        let localLoader = makeLocalLoader(id: id)

        return remoteLoader
            .caching(to: bookStore, map: LocalBookMapper.map)
            .fallback(to: localLoader)
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }

    func makeRemoteWithLocalFallbackLoader() -> AnyPublisher<[Book], Error> {
        let remoteLoader = makeRemoteLoader()
        let localLoader = makeLocalLoader()

        return remoteLoader
            .caching(to: bookStore, map: LocalBookMapper.map)
            .fallback(to: localLoader)
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }

    // MARK: - Private Methods
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

    private func makeRemoteLoader() -> AnyPublisher<[Book], Error> {
        let request = URLRequest(url: URL(string: "https://api.example.com/books")!)
        let mapper = DecodableResourceResponseMapper<[BookDTO]>()
        return client
            .perform(request)
            .tryMap(mapper.map)
            .map { $0.map(BookDTOMapper.map) }
            .eraseToAnyPublisher()
    }

    private func makeLocalLoader() -> AnyPublisher<[Book], Error> {
        localRepository.fetch()
            .map(LocalBookMapper.map)
            .eraseToAnyPublisher()
    }
}
