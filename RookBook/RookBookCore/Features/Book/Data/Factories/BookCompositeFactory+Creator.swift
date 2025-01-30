// Copyright © 2025 Mustafa Kemal Gökçe. All rights reserved.

import Combine
import Foundation

extension BookCompositeFactory {
    // MARK: - Public Methods
    public func makeRemoteWithLocalCreator(item: Book) -> AnyPublisher<Void, Error> {
        let remoteCreator = makeRemoteCreator(item: item)
        let localCreator = makeLocalCreator(item: item)

        return remoteCreator
            .runAlsoAndFallback(to: localCreator)
    }

    // MARK: - Private Methods
    private func makeRemoteCreator(item: Book) -> AnyPublisher<Void, Error> {
        let url = URL(string: "https://api.example.com/books")!
        let dto = BookDTOMapper.map(item)
        let mapper = EmptyResponseMapper()
        var request = URLRequest(url: url, method: .post)
        request.httpBody = try? JSONEncoder().encode(dto)
        return client
            .perform(request)
            .tryMap(mapper.map)
            .eraseToAnyPublisher()
    }

    private func makeLocalCreator(item: Book) -> AnyPublisher<Void, Error> {
        localRepository
            .save(LocalBookMapper.map(item))
            .eraseToAnyPublisher()
    }
}
