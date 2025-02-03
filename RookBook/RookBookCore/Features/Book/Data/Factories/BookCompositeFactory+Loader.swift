// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import Foundation

extension BookCompositeFactory {
    // MARK: - Public Methods
    public func makeRemoteWithLocalFallbackLoader(id: UUID) -> AnyPublisher<Book, Error> {
        let remoteLoader = makeRemoteLoader(id: id)
        let localLoader = makeLocalLoader(id: id)

        return remoteLoader
            .caching(to: bookStore, map: LocalBookMapper.map)
            .fallback(to: localLoader)
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }

    public func makeRemoteWithLocalFallbackLoader() -> AnyPublisher<[Book], Error> {
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
        var request = URL(string: "http://localhost:3000/api/books?limit=12&orderBy=lastReadAt&orderDirection=DESC")!
            .request()
        request.cachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        let mapper = DecodableResourceResponseMapper<BookResponse>()
        return client
            .perform(request)
            .tryMap(mapper.map)
            .map { $0.items.map(BookDTOMapper.map) }
            .eraseToAnyPublisher()
    }

    private func makeLocalLoader() -> AnyPublisher<[Book], Error> {
        localRepository.fetch()
            .map(LocalBookMapper.map)
            .eraseToAnyPublisher()
    }
}
